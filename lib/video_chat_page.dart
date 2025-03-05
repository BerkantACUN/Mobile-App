import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class VideoChatPage extends StatefulWidget {
  final String roomId;

  VideoChatPage({required this.roomId});

  @override
  _VideoChatPageState createState() => _VideoChatPageState();
}

class _VideoChatPageState extends State<VideoChatPage> {
  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();
  late WebSocketChannel _channel;
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;

  @override
  void initState() {
    super.initState();
    initRenderers();
    _connectToWebSocket();
  }

  // WebSocket bağlantısı kurma
  Future<void> _connectToWebSocket() async {
    _channel = WebSocketChannel.connect(Uri.parse('ws://localhost:5000'));
    _channel.stream.listen(
      (message) {
        try {
          var decodedMessage = jsonDecode(message);
          handleMessage(decodedMessage);
        } catch (e) {
          print("Error parsing message: $e");
        }
      },
      onError: (error) => print("WebSocket error: $error"),
      onDone: () => print("WebSocket connection closed"),
    );
  }

  // Renderers başlatma
  Future<void> initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
    await startVideo();
  }

  // Video başlatma
  Future<void> startVideo() async {
    final mediaConstraints = {'audio': true, 'video': true};

    try {
      _localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
      _localRenderer.srcObject = _localStream;

      // Odaya katılma mesajı
      _channel.sink.add(jsonEncode({
        "type": "join_room", 
        "roomId": widget.roomId
      }));

      await _createPeerConnection();
    } catch (e) {
      print("Error starting video: $e");
    }
  }

  // WebRTC PeerConnection oluşturma
  Future<void> _createPeerConnection() async {
    final configuration = {
      'iceServers': [{'urls': 'stun:stun.l.google.com:19302'}]
    };

    _peerConnection = await createPeerConnection(configuration);
    
    if (_localStream != null) {
      for (var track in _localStream!.getTracks()) {
        _peerConnection!.addTrack(track, _localStream!);
      }
    }

    _peerConnection!.onIceCandidate = (RTCIceCandidate? candidate) {
      if (candidate != null) {
        _channel.sink.add(jsonEncode({
          'type': 'ice_candidate',
          'candidate': candidate.candidate,
          'sdpMid': candidate.sdpMid,
          'sdpMLineIndex': candidate.sdpMLineIndex
        }));
      }
    };

    _peerConnection!.onTrack = (RTCTrackEvent event) {
      _remoteRenderer.srcObject = event.streams.first;
    };

    await _createOffer();
  }

  // Teklif oluşturma
  Future<void> _createOffer() async {
    if (_peerConnection == null) return;
    final RTCSessionDescription offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);
    _channel.sink.add(jsonEncode({
      'type': 'offer',
      'sdp': offer.sdp,
      'roomId': widget.roomId
    }));
  }

  // Mesajları işleme
  void handleMessage(dynamic message) {
    switch (message['type']) {
      case 'offer':
        _handleOffer(message['sdp']);
        break;
      case 'answer':
        _handleAnswer(message['sdp']);
        break;
      case 'ice_candidate':
        _handleIceCandidate(message);
        break;
    }
  }

  // Teklif işleme
  Future<void> _handleOffer(String sdp) async {
    if (_peerConnection == null) return;
    await _peerConnection!.setRemoteDescription(
      RTCSessionDescription(sdp, 'offer'),
    );
    final answer = await _peerConnection!.createAnswer();
    await _peerConnection!.setLocalDescription(answer);
    _channel.sink.add(jsonEncode({
      'type': 'answer',
      'sdp': answer.sdp,
      'roomId': widget.roomId
    }));
  }

  // Cevap işleme
  Future<void> _handleAnswer(String sdp) async {
    if (_peerConnection == null) return;
    await _peerConnection!.setRemoteDescription(
      RTCSessionDescription(sdp, 'answer'),
    );
  }

  // ICE adaylarını işleme
  void _handleIceCandidate(Map<String, dynamic> candidateData) {
    if (_peerConnection == null) return;
    RTCIceCandidate candidate = RTCIceCandidate(
      candidateData['candidate'],
      candidateData['sdpMid'],
      candidateData['sdpMLineIndex'],
    );
    _peerConnection!.addCandidate(candidate);
  }

  @override
  void dispose() {
    _channel.sink.close();
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _peerConnection?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video Sohbet')),
      body: Column(
        children: [
          Expanded(child: RTCVideoView(_localRenderer)),
          Expanded(child: RTCVideoView(_remoteRenderer)),
        ],
      ),
    );
  }
}

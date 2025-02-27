import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoCallPage extends StatefulWidget {
  const VideoCallPage({Key? key}) : super(key: key);

  @override
  _VideoCallPageState createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;

  @override
  void initState() {
    super.initState();
    initRenderers();
    _createPeerConnection();
  }

  Future<void> initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  Future<void> _createPeerConnection() async {
    _peerConnection = await createPeerConnection({
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ],
    });

    _peerConnection?.onIceCandidate = (candidate) {
      // ICE adaylarını işle
      print('Yeni ICE adayı: ${candidate.candidate}');
    };

    _peerConnection?.onAddStream = (stream) {
      setState(() {
        _remoteRenderer.srcObject = stream;
      });
    };

    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': true,
    });

    _localRenderer.srcObject = _localStream;
    _peerConnection?.addStream(_localStream!);
  }

  Future<void> _makeCall() async {
    final offer = await _peerConnection?.createOffer();
    await _peerConnection?.setLocalDescription(offer!);

    // Sinyal sunucusuna offer gönder
    // Örnek: _socket.emit('offer', {'sdp': offer.sdp, 'type': offer.type});
    print('Offer gönderildi: ${offer?.sdp}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Görüntülü Görüşme"),
      ),
      body: Column(
        children: [
          Expanded(
            child: RTCVideoView(_localRenderer),
          ),
          Expanded(
            child: RTCVideoView(_remoteRenderer),
          ),
          ElevatedButton(
            onPressed: _makeCall,
            child: const Text("Çağrı Başlat"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _peerConnection?.close();
    super.dispose();
  }
}
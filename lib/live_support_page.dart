import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class LiveSupportPage extends StatefulWidget {
  const LiveSupportPage({Key? key}) : super(key: key);

  @override
  _LiveSupportPageState createState() => _LiveSupportPageState();
}

class _LiveSupportPageState extends State<LiveSupportPage> {
  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  IO.Socket? _socket;

  @override
  void initState() {
    super.initState();
    initRenderers();
    _initSocket();
    _createPeerConnection();
  }

  Future<void> initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  void _initSocket() {
    _socket = IO.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
    });

    _socket?.on('connect', (_) {
      print('Sinyal sunucusuna bağlandı');
    });

    _socket?.on('offer', (data) async {
  try {
    final description = RTCSessionDescription(data['sdp'], data['type']);
    await _peerConnection?.setRemoteDescription(description);

    // Answer oluşturulurken hata kontrolü ekleyelim
    final answer = await _peerConnection?.createAnswer();
    if (answer != null) {
      await _peerConnection?.setLocalDescription(answer);

      // SDP ve type değerlerini güvenli şekilde kullanıyoruz
      _socket?.emit('answer', {
        'sdp': answer.sdp,
        'type': answer.type,
      });
    } else {
      print("Answer oluşturulurken bir sorun oluştu");
    }
  } catch (e) {
    print("Offer işlenirken hata: $e");
  }
});


    _socket?.on('answer', (data) async {
      try {
        final description = RTCSessionDescription(data['sdp'], data['type']);
        await _peerConnection?.setRemoteDescription(description);
      } catch (e) {
        print("Answer işlenirken hata: $e");
      }
    });

    _socket?.on('candidate', (data) async {
      try {
        final candidate = RTCIceCandidate(
          data['candidate'],
          data['sdpMid'],
          data['sdpMLineIndex'],
        );
        await _peerConnection?.addCandidate(candidate);
      } catch (e) {
        print("Candidate işlenirken hata: $e");
      }
    });
  }

  Future<void> _createPeerConnection() async {
    try {
      _peerConnection = await createPeerConnection({
        'iceServers': [
          {'urls': 'stun:stun.l.google.com:19302'},
        ],
      });

      _peerConnection?.onIceCandidate = (candidate) {
        _socket?.emit('candidate', {
          'candidate': candidate.candidate,
          'sdpMid': candidate.sdpMid,
          'sdpMLineIndex': candidate.sdpMLineIndex,
        });
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
      _peerConnection?.addTrack(_localStream!.getTracks().first);
    } catch (e) {
      print("Peer connection oluşturulurken hata: $e");
    }
  }

  Future<void> _makeCall() async {
    try {
      final offer = await _peerConnection?.createOffer();
      if (offer != null) {
        await _peerConnection?.setLocalDescription(offer);
        _socket?.emit('offer', {
          'sdp': offer.sdp,
          'type': offer.type,
        });
      }
    } catch (e) {
      print("Offer oluşturulurken hata: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Canlı Destek"),
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
    _socket?.disconnect();
    super.dispose();
  }
}

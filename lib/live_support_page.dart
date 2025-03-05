import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';

class LiveSupportPage extends StatefulWidget {
  final String roomId;
  LiveSupportPage({required this.roomId});

  @override
  _LiveSupportPageState createState() => _LiveSupportPageState();
}

class _LiveSupportPageState extends State<LiveSupportPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _requestPermissions().then((granted) {
      if (granted) {
        _initializeWebRTC();
      } else {
        print("Gerekli izinler verilmedi!");
      }
    });
  }

  Future<bool> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone
    ].request();
    return statuses[Permission.camera]!.isGranted && statuses[Permission.microphone]!.isGranted;
  }

  Future<void> _initializeWebRTC() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();

    _localStream = await navigator.mediaDevices.getUserMedia({
      'video': true,
      'audio': true,
    });
    _localRenderer.srcObject = _localStream;

    Map<String, dynamic> config = {
      "iceServers": [{"urls": "stun:stun.l.google.com:19302"}],
    };

    _peerConnection = await createPeerConnection(config);
    _peerConnection?.addStream(_localStream!);

    _peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
      _firestore.collection("rooms").doc(widget.roomId).collection("candidates").add(candidate.toMap());
    };

    _peerConnection?.onTrack = (RTCTrackEvent event) {
      if (event.track.kind == 'video') {
        _remoteRenderer.srcObject = event.streams[0];
      }
    };

    _checkRoom();
  }

  Future<void> _checkRoom() async {
    DocumentSnapshot roomSnapshot = await _firestore.collection("rooms").doc(widget.roomId).get();

    if (roomSnapshot.exists) {
      _joinCall();
    } else {
      _createRoom();
    }
  }

  Future<void> _createRoom() async {
    RTCSessionDescription offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);

    await _firestore.collection("rooms").doc(widget.roomId).set({
      'offer': offer.toMap(),
    });
  }

  Future<void> _joinCall() async {
    DocumentSnapshot roomSnapshot = await _firestore.collection("rooms").doc(widget.roomId).get();

    if (!roomSnapshot.exists || !(roomSnapshot.data() as Map<String, dynamic>).containsKey('offer')) {
      await _createRoom();
      return;
    }

    RTCSessionDescription offer = RTCSessionDescription(
      (roomSnapshot.data() as Map<String, dynamic>)['offer']['sdp'],
      (roomSnapshot.data() as Map<String, dynamic>)['offer']['type'],
    );
    await _peerConnection!.setRemoteDescription(offer);

    RTCSessionDescription answer = await _peerConnection!.createAnswer();
    await _peerConnection!.setLocalDescription(answer);

    await _firestore.collection("rooms").doc(widget.roomId).update({
      'answer': answer.toMap(),
    });

    _firestore.collection("rooms").doc(widget.roomId).collection("candidates").snapshots().listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          RTCIceCandidate candidate = RTCIceCandidate(
            change.doc['candidate'],
            change.doc['sdpMid'],
            change.doc['sdpMLineIndex'],
          );
          _peerConnection!.addCandidate(candidate);
        }
      }
    });

    _startJina();
  }

  void _startJina() async {
    try {
      final response = await http.post(
        Uri.parse("https://jina-api-endpoint.com/start"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"roomId": widget.roomId, "caller": "customer"}),
      );
      if (response.statusCode == 200) {
        print("Jina başarıyla başlatıldı.");
      }
    } catch (e) {
      print("Jina başlatma hatası: $e");
    }
  }

  void sendMessage(String messageText) async {
    if (messageText.trim().isEmpty) return;
    await _firestore.collection("rooms").doc(widget.roomId).collection("messages").add({
      'sender': "user1",
      'text': messageText,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _peerConnection?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Canlı Destek - Room ID: ${widget.roomId}')),
      body: Column(
        children: [
          Expanded(child: RTCVideoView(_localRenderer)),
          Expanded(child: RTCVideoView(_remoteRenderer)),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection("rooms").doc(widget.roomId).collection("messages").orderBy('timestamp', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                var messages = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    return ListTile(
                      title: Text(message['sender']),
                      subtitle: Text(message['text']),
                    );
                  },
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(child: TextField(controller: _messageController, decoration: InputDecoration(hintText: "Mesaj yaz..."))),
              IconButton(icon: Icon(Icons.send), onPressed: () {
                sendMessage(_messageController.text);
                _messageController.clear();
              }),
            ],
          ),
        ],
      ),
    );
  }
}
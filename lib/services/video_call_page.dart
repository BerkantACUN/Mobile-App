import 'package:flutter/material.dart';
import '../services/firestore_webrtc_service.dart';

class VideoCallPage extends StatefulWidget {
  @override
  _VideoCallPageState createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  final FirestoreWebRTCService webrtcService = FirestoreWebRTCService();
  String? roomId;

  void createNewRoom() async {
    String newRoomId = await webrtcService.createRoom("örnek_offer_sdp");
    setState(() {
      roomId = newRoomId;
    });

    print("Yeni oda ID: $newRoomId");
  }

  void addAnswer() async {
    if (roomId != null) {
      await webrtcService.addAnswerToRoom(roomId!, "örnek_answer_sdp");
      print("Answer eklendi!");
    }
  }

  void addIce() async {
    if (roomId != null) {
      await webrtcService.addIceCandidate(roomId!, "örnek_candidate", 0, "audio");
      print("ICE eklendi!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Video Call")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: createNewRoom,
              child: Text("Yeni Oda Oluştur"),
            ),
            ElevatedButton(
              onPressed: addAnswer,
              child: Text("Answer Ekle"),
            ),
            ElevatedButton(
              onPressed: addIce,
              child: Text("ICE Candidate Ekle"),
            ),
          ],
        ),
      ),
    );
  }
}

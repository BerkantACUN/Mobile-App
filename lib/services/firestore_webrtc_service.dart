import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreWebRTCService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// 📌 1. Yeni Oda Oluştur ve Offer SDP Kaydet
  Future<String> createRoom(String offerSdp) async {
    DocumentReference roomRef = firestore.collection('rooms').doc();
    
    await roomRef.set({
      'offer': {
        'sdp': offerSdp,
        'type': 'offer'
      },
      'answer': {
        'sdp': '',
        'type': ''
      }
    });

    print("Oda oluşturuldu: ${roomRef.id}");
    return roomRef.id;
  }

  /// 📌 2. Answer SDP Ekle (Karşı Taraf)
  Future<void> addAnswerToRoom(String roomId, String answerSdp) async {
    await firestore.collection('rooms').doc(roomId).update({
      'answer': {
        'sdp': answerSdp,
        'type': 'answer'
      }
    });

    print("Answer eklendi: $roomId");
  }

  /// 📌 3. ICE Candidate Ekle
  Future<void> addIceCandidate(String roomId, String candidate, int sdpMLineIndex, String sdpMid) async {
    await firestore.collection('rooms').doc(roomId).collection('candidates').add({
      'candidate': candidate,
      'sdpMLineIndex': sdpMLineIndex,
      'sdpMid': sdpMid
    });

    print("ICE Candidate eklendi: $roomId");
  }

  /// 📌 4. ICE Candidate'leri Dinle (Gerçek Zamanlı)
  void listenForIceCandidates(String roomId) {
    firestore.collection('rooms').doc(roomId).collection('candidates').snapshots().listen((snapshot) {
      for (var doc in snapshot.docs) {
        print("Yeni ICE Candidate: ${doc.data()}");
      }
    });
  }
}

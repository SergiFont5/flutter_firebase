import 'package:cloud_firestore/cloud_firestore.dart';

class ServicioChat {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String getChatId(String uid1, String uid2) {
    final uids = [uid1, uid2]..sort();
    return uids.join('_');
  }

  Stream<QuerySnapshot> getMensajes(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('mensajes')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<void> enviarMensaje({
    required String chatId,
    required String texto,
    required String autorUid,
    required String autorNombre,
  }) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('mensajes')
        .add({
      'texto': texto,
      'autorUid': autorUid,
      'autorNombre': autorNombre,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}

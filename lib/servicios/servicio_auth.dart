import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServicioAuth {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> registrarUsuarioConEmailPassword(String email, String password) async {
    try {
      /*
        al crear un registro, se hace el login automático
       */ 
      UserCredential credencialUsuario = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      final uid = credencialUsuario.user!.uid;

      await _firestore.collection("usuarios").doc(uid).set(
        {
          "uid": uid,
          "email": email,
          "nombre": "",
          "fecha_registro": FieldValue.serverTimestamp(),
        }
      );

      return null;

    } on FirebaseAuthException catch (e) {

      switch (e.code) {
        case "email-already-in-use":
          return "Email en uso";
        case "invalid-email":
          return "El email no es válido";
        case "operation-not-allowed":
          return "Registro no permitido";
        case "weak-password":
          return "El email no es válido";
        default:
          return "Error: ${e.message}";
      }
      
    } on FirebaseException catch (e) {
      return e.message;  
    }
  }

  Future <void> logout() async {
    await _auth.signOut();
  }
  
}
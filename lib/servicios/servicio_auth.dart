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

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<String?> recuperarPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          return "El email no es válido";
        case "user-not-found":
          return "No existe una cuenta con ese email";
        default:
          return "Error: ${e.message}";
      }
    }
  }

  Future<String?> login(String email, String password) async {
    try {

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Si ha pogut fer login, mirem si té dades a Firestore. Podria ser que
      // algun usuari s'hagi creat des de la consola de Firebase i no des de
      // la nostra aplicació, amb la qual cosa, tindria credencials d'accés,
      // però no tindria cap dada. Anem a:
      //     1) Mirem si aquest usuari té document de dades a Firestore.
      //     2) Si no el té, el creem (com quan fem el registre des de l'app).

      // Extraemos el UID:
      final uid = _auth.currentUser!.uid;
      // Con este UID miramos si hay datos de firestore asociados
      final docUsuario = await _firestore.collection("usuarios").doc(uid).get();

      // Si no encuentra el documento lo creamos
      if(!docUsuario.exists) {
        await _firestore.collection("usuarios").doc(uid).set(
          {
            "uid": uid,
            "email": email,
            "nombre": "",
            "fecha_registro": FieldValue.serverTimestamp(),
          }
        );
      }

    } on FirebaseAuthException catch (e) {

      switch (e.code) {
        case "invalid-email":
          return "El email no es válido";
        case "weak-password":
          return "El email no es válido";
        default:
          return "Error: ${e.message}";
      }
      
    } on FirebaseException catch (e) {
      return e.message;  
    }
  }
  
}
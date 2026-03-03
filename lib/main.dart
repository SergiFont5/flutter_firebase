import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/firebase_options.dart';
import 'package:flutter_firebase/pagines/pagina_registre.dart';
import 'package:google_fonts/google_fonts.dart';


/*
1- crear proyecto en firebase
  Habilitados los servicios:
  - FirebaseAuth
  - Firestore Database
2- Instalar node.js, instalar npm
3- Instalar FirebaseCLI globalmente con npm:
    habilitar scripts: Set-ExecutionPolicy -Scope Process -ExecutionPolivy Bypass
    npm install -g firebase-tools
4- Login cuenta de google:
    firebase login

5- activar cli:
  flutter pub global activate flutterfire_cli
6- vincular el proyecto flutter con el proyecto online
  flutterfire configure -> Se crea el archivo firenase_options.dart (aparecen errores)
  Si el repositorio es público, añadir este archivo creado en el gitignore.
  Este archivo (firebase_options.dart) contiene las id's y llaves para utilizar los
  servicios de firebase de nuestra cuenta y proyecto.
 */

/*
 Dependencias de firebase:

 flutter pub add firebase_core    -> para el núcleo de firebase (se arreglan errores de arriba)
 flutter pub add firebase_auth    -> autenticacion de firebase
 flutter pub add cloud_firestore  -> servicio para firebase database
 
 */

void main() async {

  // asegura que firebase esté inicializado
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint("Firebase iniciado");
  } catch (e) {
    debugPrint("Error al iniciar firebase: $e");
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.icelandTextTheme(
          Theme.of(context).textTheme,
        ).apply(fontSizeFactor: 1.15),
      ),
      title: "si",
      home: const PaginaRegistre(),
        );
  }
}

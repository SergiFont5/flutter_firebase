import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/pagines/login_o_registro.dart';
import 'package:flutter_firebase/pagines/pagina_inici.dart';

class PortalAuth extends StatelessWidget {
  const PortalAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(), // avisa si hay cambios en estado auth
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("ERROR"));
          }

          if (snapshot.hasData) {
            // usuario autenticado, mostrar pagina de inicio
            return PaginaInicio();

          } else {
            // decidir si mostrar login o registro
            return LoginORegistro();
          }
        },
      ),
    );
  }
}
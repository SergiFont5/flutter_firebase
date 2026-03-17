import 'package:flutter/material.dart';
import 'package:flutter_firebase/pagines/pagina_login.dart';
import 'package:flutter_firebase/pagines/pagina_registre.dart';

class LoginORegistro extends StatefulWidget {
  const LoginORegistro({super.key});

  @override
  State<LoginORegistro> createState() => _LoginORegistroState();
}

class _LoginORegistroState extends State<LoginORegistro> {

  bool _mostrarLogin = true;

  void intercambiarPaginas() {
    setState(() {
      _mostrarLogin = !_mostrarLogin;
    });
  }



  @override
  Widget build(BuildContext context) {

    if (_mostrarLogin) {

      return PaginaLogin(intercambiarARegistro: intercambiarPaginas,);

    } else {

      return PaginaRegistre(intercambiarALogin: intercambiarPaginas,);
      
    }

  }
}
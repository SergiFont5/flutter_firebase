import 'package:flutter/material.dart';
import 'package:flutter_firebase/componentes/titulo_artistico.dart';
import 'package:flutter_firebase/servicios/servicio_auth.dart';
import 'package:flutter_firebase/utils/colores_app.dart';

class PaginaInicio extends StatelessWidget {
  const PaginaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColoresApp.colorApoyoIntenso,
        title: TituloArtistico(textoTitulo: "Conecta app"),
        actions: [IconButton(
          onPressed: () {
            ServicioAuth().logout();
          }, 
          icon: Icon(Icons.logout, color: ColoresApp.colorSecundario, )
          )],
      ),
      body: SafeArea(child: SingleChildScrollView()),
    );
  }
}
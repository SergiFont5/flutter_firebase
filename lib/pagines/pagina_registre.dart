import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_firebase/componentes/titulo_artistico.dart';
import 'package:flutter_firebase/utils/colores_app.dart';
import 'package:flutter_firebase/utils/variables.dart';

class PaginaRegistre extends StatelessWidget {
  const PaginaRegistre({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("${Variables.pathImages}background1.jpg", fit: BoxFit.cover,),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(color: Color.fromARGB(98, 0, 0, 0),),
            ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Icon(
                      Icons.group_work_outlined,
                      size: 140,
                      color: ColoresApp.colorSecundario,
                      shadows: [
                        Shadow(
                          color: ColoresApp.colorSecundarioIntenso,
                          blurRadius: 8,
                        )
                      ],
                    ),
                    TituloArtistico(textoTitulo: "Mi libro..."),
                    // formulario
                    /**********************/
                    // email
                    // password
                    // password confirm
                    // boton registrar
                    // preguntar si ya tiene cuenta
                    //
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

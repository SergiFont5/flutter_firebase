import 'package:flutter/material.dart';
import 'package:flutter_firebase/utils/colores_app.dart';
import 'package:google_fonts/google_fonts.dart';

class TituloArtistico extends StatelessWidget {
  final String textoTitulo;

  const TituloArtistico({super.key, required this.textoTitulo});

  @override
  Widget build(BuildContext context) {
    return Text(
      textoTitulo,
      style: GoogleFonts.asimovian(
        color: ColoresApp.colorSecundario,
        fontWeight: FontWeight.bold,
        fontSize: 40,
        shadows: [
          Shadow(color: ColoresApp.colorSecundarioIntenso, blurRadius: 8),
          Shadow(color: ColoresApp.colorSecundario, blurRadius: 2),
        ],
      ),
    );
  }
}

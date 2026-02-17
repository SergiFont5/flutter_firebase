import 'package:flutter/material.dart';
import 'package:flutter_firebase/utils/colores_app.dart';

class TextoNormal extends StatelessWidget {
  final String contenidoTexto;
  final Color colorTexto;

  const TextoNormal({
    super.key, 
    required this.contenidoTexto, 
    this.colorTexto = ColoresApp.colorPrimarioIntenso
    });

  @override
  Widget build(BuildContext context) {
    return Text(
      contenidoTexto,
      style: TextStyle(
        fontSize: 24,
        color: colorTexto,
        fontWeight: FontWeight.bold
      ),
      );
  }
}
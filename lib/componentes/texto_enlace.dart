import 'package:flutter/material.dart';
import 'package:flutter_firebase/utils/colores_app.dart';

class TextoEnlace extends StatelessWidget {

  final String contenidoTexto;
  final Color colorTexto;

  final Function()? accionEnlace;

  const TextoEnlace({
    super.key, 
    required this.contenidoTexto, 
    this.colorTexto = ColoresApp.colorPrimarioIntenso,
    required this.accionEnlace
    });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: accionEnlace,
      child: Text(
        contenidoTexto,
        style: TextStyle(
          fontSize: 24,
          color: colorTexto,
          fontWeight: FontWeight.bold
        ),
        ),
    );;
  }
}
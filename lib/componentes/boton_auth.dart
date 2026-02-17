import 'package:flutter/material.dart';
import 'package:flutter_firebase/utils/colores_app.dart';
import 'package:flutter_firebase/utils/variables.dart';

class BotonAuth extends StatelessWidget {

  final Function()? accionBoton;
  final String textoBoton;

  const BotonAuth({super.key, required this.textoBoton, this.accionBoton});

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: accionBoton,
      child: Container(
        width: 300,
        height: 100,
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            Image.asset("${Variables.pathImages}boto.png", fit: BoxFit.fill),
            Center(
              child: Text(
                textoBoton,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: ColoresApp.colorSecundario,
                  letterSpacing: 3,
                  shadows: [
                    Shadow(
                      color: ColoresApp.colorSecundarioIntenso,
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

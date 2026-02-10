import 'package:flutter/material.dart';
import 'package:flutter_firebase/utils/colores_app.dart';

class TextfieldAutenticacion extends StatefulWidget {

  final TextEditingController controladorTexto;
  final bool ocultarTexto;
  final bool isPassword;
  final String hintText;
  final FocusNode? focusNode;

  const TextfieldAutenticacion({
    super.key,
    required this.controladorTexto,
    this.ocultarTexto = true,
    this.focusNode,
    required this.hintText,
    this.isPassword = false

    });

  @override
  State<TextfieldAutenticacion> createState() => _TextfieldAutenticacionState();
}

class _TextfieldAutenticacionState extends State<TextfieldAutenticacion> {
  late bool _ocultarTexto;

  @override
  void initState() {
    super.initState();

    _ocultarTexto = widget.ocultarTexto;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: _ocultarTexto && widget.isPassword,
      obscuringCharacter: "*",
      controller: widget.controladorTexto,
      focusNode: widget.focusNode,

      style: TextStyle(
        color: ColoresApp.colorSecundario,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(color: ColoresApp.colorSecundarioIntenso, blurRadius: 4)
        ]
      ),

      cursorColor: ColoresApp.colorSecundario,
      cursorWidth: 2,
      cursorHeight: 24,

      decoration: InputDecoration(
        fillColor: ColoresApp.colorApoyoIntenso,
        filled: true,

        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: ColoresApp.colorSecundario,
          fontStyle: FontStyle.italic,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: ColoresApp.colorPrimario, width: 1)
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: ColoresApp.colorPrimarioIntenso, width: 3)
        ),

        suffixIcon: Padding(padding: const EdgeInsets.only(right: 4),
        child: widget.isPassword ? 
          IconButton(onPressed: () {
            setState(() {
              _ocultarTexto = !_ocultarTexto;
            });
          }, icon: Icon(
            _ocultarTexto ? Icons.visibility_off : Icons.visibility),
            color: ColoresApp.colorPrimarioIntenso,
            ) :
          null,
        )
      ),
    );
  }
}
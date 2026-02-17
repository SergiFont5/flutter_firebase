import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_firebase/componentes/boton_auth.dart';
import 'package:flutter_firebase/componentes/textfield_autenticacion.dart';
import 'package:flutter_firebase/componentes/texto_normal.dart';
import 'package:flutter_firebase/componentes/titulo_artistico.dart';
import 'package:flutter_firebase/utils/colores_app.dart';
import 'package:flutter_firebase/utils/variables.dart';

class PaginaRegistre extends StatefulWidget {
  const PaginaRegistre({super.key});

  @override
  State<PaginaRegistre> createState() => _PaginaRegistreState();
}

class _PaginaRegistreState extends State<PaginaRegistre> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _llaveFormulario = GlobalKey<FormState>();

  String? _validarEmail(String? valorEmail) {
    if (valorEmail == null || valorEmail.trim().isEmpty) {
      return "El email es necesario";
    }
    return null;
  }

  void _handleLogin() {
    if (_llaveFormulario.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Credenciales correctas"),),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error"),),
      );
    }
  }

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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _llaveFormulario,
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
                        SizedBox(height: 20,),
                        // formulario
                        /**********************/
                    
                        // EMAIL
                        TextfieldAutenticacion(
                          controladorTexto: _emailController, 
                          hintText: "Insert Email...",
                          validacion: _validarEmail,
                          ),
                        SizedBox(height: 20,),
                    
                        // PASSWORD
                        TextfieldAutenticacion(controladorTexto: _passwordController, hintText: "Insert Password...", isPassword: true,),
                        SizedBox(height: 20,),
                    
                        // CONFIRM PASSWORD
                        TextfieldAutenticacion(controladorTexto: _confirmPasswordController, hintText: "Insert Password again...", isPassword: true,),
                    
                        SizedBox(height: 20,),
                        
                        // boton registrar
                        BotonAuth(textoBoton: "Registrar", accionBoton: _handleLogin,),
                    
                        SizedBox(height: 20,),
                        
                        // preguntar si ya tiene cuenta
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextoNormal(contenidoTexto: "¿Ya tienes cuenta?",),
                            TextoNormal(contenidoTexto: "Haz login", colorTexto: ColoresApp.colorResalto,),
                          ],
                        )
                        //
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

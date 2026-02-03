import 'package:flutter/material.dart';
import 'package:flutter_firebase/pagines/pagina_registre.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.icelandTextTheme(
          Theme.of(context).textTheme,
        ).apply(fontSizeFactor: 1.15),
      ),
      title: "si",
      home: const PaginaRegistre(),
        );
  }
}

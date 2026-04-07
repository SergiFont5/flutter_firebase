import 'package:flutter/material.dart';
import 'package:flutter_firebase/utils/colores_app.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),

      decoration: BoxDecoration(),

      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: ColoresApp.colorPrimarioIntenso, width: 2),
            ),
            child: Icon(Icons.person, size: 28, color: ColoresApp.colorPrimarioIntenso,),
          ),

          SizedBox(width: 10,),

          Column(
            children: [
              Text("Email"),
              SizedBox(height: 4,),
              Text("Nombre usuario")
            ],
          )
        ],
      ),
    );
  }
}
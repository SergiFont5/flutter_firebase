import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/componentes/titulo_artistico.dart';
import 'package:flutter_firebase/pagines/pagina_chat.dart';
import 'package:flutter_firebase/servicios/servicio_auth.dart';
import 'package:flutter_firebase/utils/colores_app.dart';

class PaginaInicio extends StatefulWidget {
  const PaginaInicio({super.key});

  @override
  State<PaginaInicio> createState() => _PaginaInicioState();
}

class _PaginaInicioState extends State<PaginaInicio> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _comprobarNombre());
  }

  Future<void> _comprobarNombre() async {
    final uid = _auth.currentUser!.uid;
    final doc = await _firestore.collection('usuarios').doc(uid).get();
    if (!mounted) return;
    final nombre = doc.data()?['nombre'] as String? ?? '';
    if (nombre.isEmpty) {
      _mostrarDialogEditarNombre();
    }
  }

  void _mostrarDialogEditarNombre() {
    final uid = _auth.currentUser!.uid;
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ColoresApp.colorApoyoIntenso,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: ColoresApp.colorPrimarioIntenso, width: 2),
            borderRadius: BorderRadiusGeometry.circular(10),
          ),
          title: Text(
            "¿Cómo te llamas?",
            style: TextStyle(color: ColoresApp.colorSecundario, fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            style: TextStyle(color: ColoresApp.colorSecundario),
            cursorColor: ColoresApp.colorSecundario,
            decoration: InputDecoration(
              hintText: "Tu nombre...",
              hintStyle: TextStyle(color: ColoresApp.colorSecundario, fontStyle: FontStyle.italic),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColoresApp.colorPrimario),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColoresApp.colorPrimarioIntenso, width: 2),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final nombre = controller.text.trim();
                if (nombre.isEmpty) return;
                await _firestore.collection('usuarios').doc(uid).update({'nombre': nombre});
                if (!mounted) return;
                Navigator.pop(context);
              },
              child: Text(
                "Guardar",
                style: TextStyle(color: ColoresApp.colorPrimarioIntenso, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final uidActual = _auth.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColoresApp.colorApoyoIntenso,
        title: TituloArtistico(textoTitulo: "Conecta app"),
        actions: [
          IconButton(
            onPressed: _mostrarDialogEditarNombre,
            icon: Icon(Icons.person, color: ColoresApp.colorSecundario),
            tooltip: "Editar nombre",
          ),
          IconButton(
            onPressed: () => ServicioAuth().logout(),
            icon: Icon(Icons.logout, color: ColoresApp.colorSecundario),
          ),
        ],
      ),
      backgroundColor: ColoresApp.colorApoyoIntenso,
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('usuarios').orderBy('fecha_registro', descending: false).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: ColoresApp.colorPrimario));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text("No hay usuarios", style: TextStyle(color: ColoresApp.colorSecundario)),
              );
            }

            final usuarios = snapshot.data!.docs;

            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: usuarios.length,
              separatorBuilder: (_, __) => Divider(color: ColoresApp.colorPrimario.withAlpha(80), height: 1),
              itemBuilder: (context, index) {
                final data = usuarios[index].data() as Map<String, dynamic>;
                final uid = data['uid'] as String? ?? '';
                final nombre = data['nombre'] as String? ?? '';
                final email = data['email'] as String? ?? '';
                final esYo = uid == uidActual;
                final displayName = nombre.isNotEmpty ? nombre : email;
                final inicial = displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';

                return ListTile(
                  onTap: esYo
                      ? null
                      : () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PaginaChat(
                                otroUid: uid,
                                otroNombre: displayName,
                              ),
                            ),
                          ),
                  leading: CircleAvatar(
                    backgroundColor: esYo ? ColoresApp.colorPrimarioIntenso : ColoresApp.colorSecundarioIntenso,
                    child: Text(
                      inicial,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    esYo ? "$displayName (tú)" : displayName,
                    style: TextStyle(
                      color: ColoresApp.colorSecundario,
                      fontWeight: esYo ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: nombre.isNotEmpty
                      ? Text(email, style: TextStyle(color: ColoresApp.colorPrimarioIntenso, fontSize: 12))
                      : null,
                  trailing: esYo
                      ? null
                      : Icon(Icons.chat_bubble_outline, color: ColoresApp.colorPrimario, size: 20),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

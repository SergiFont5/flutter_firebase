import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/servicios/servicio_chat.dart';
import 'package:flutter_firebase/utils/colores_app.dart';

class PaginaChat extends StatefulWidget {
  final String otroUid;
  final String otroNombre;

  const PaginaChat({
    super.key,
    required this.otroUid,
    required this.otroNombre,
  });

  @override
  State<PaginaChat> createState() => _PaginaChatState();
}

class _PaginaChatState extends State<PaginaChat> {
  final _servicio = ServicioChat();
  final _auth = FirebaseAuth.instance;
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  late final String _chatId;
  late final String _miUid;
  late final String _miNombre;

  @override
  void initState() {
    super.initState();
    _miUid = _auth.currentUser!.uid;
    _chatId = _servicio.getChatId(_miUid, widget.otroUid);
    _cargarNombrePropio();
  }

  Future<void> _cargarNombrePropio() async {
    final doc = await FirebaseFirestore.instance.collection('usuarios').doc(_miUid).get();
    _miNombre = doc.data()?['nombre'] as String? ?? _auth.currentUser!.email ?? 'Yo';
  }

  Future<void> _enviar() async {
    final texto = _controller.text.trim();
    if (texto.isEmpty) return;
    _controller.clear();
    await _servicio.enviarMensaje(
      chatId: _chatId,
      texto: texto,
      autorUid: _miUid,
      autorNombre: _miNombre,
    );
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 100,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.colorApoyoIntenso,
      appBar: AppBar(
        backgroundColor: ColoresApp.colorApoyoIntenso,
        iconTheme: IconThemeData(color: ColoresApp.colorSecundario),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: ColoresApp.colorSecundarioIntenso,
              radius: 18,
              child: Text(
                widget.otroNombre.isNotEmpty ? widget.otroNombre[0].toUpperCase() : '?',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(width: 10),
            Text(
              widget.otroNombre,
              style: TextStyle(color: ColoresApp.colorSecundario, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _servicio.getMensajes(_chatId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: ColoresApp.colorPrimario));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      "Sé el primero en escribir",
                      style: TextStyle(color: ColoresApp.colorPrimarioIntenso, fontStyle: FontStyle.italic),
                    ),
                  );
                }

                final mensajes = snapshot.data!.docs;

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                  }
                });

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemCount: mensajes.length,
                  itemBuilder: (context, index) {
                    final data = mensajes[index].data() as Map<String, dynamic>;
                    final esMio = (data['autorUid'] as String?) == _miUid;
                    final texto = data['texto'] as String? ?? '';
                    final nombre = data['autorNombre'] as String? ?? '';

                    return Align(
                      alignment: esMio ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
                        decoration: BoxDecoration(
                          color: esMio ? ColoresApp.colorPrimarioIntenso : ColoresApp.colorSecundarioIntenso,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                            bottomLeft: esMio ? Radius.circular(16) : Radius.circular(4),
                            bottomRight: esMio ? Radius.circular(4) : Radius.circular(16),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: esMio ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            if (!esMio)
                              Text(
                                nombre,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white70,
                                ),
                              ),
                            Text(
                              texto,
                              style: TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          _BarraEscritura(controller: _controller, onEnviar: _enviar),
        ],
      ),
    );
  }
}

class _BarraEscritura extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onEnviar;

  const _BarraEscritura({required this.controller, required this.onEnviar});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColoresApp.colorApoyoIntenso,
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: TextStyle(color: ColoresApp.colorSecundario),
              cursorColor: ColoresApp.colorSecundario,
              onSubmitted: (_) => onEnviar(),
              decoration: InputDecoration(
                hintText: "Escribe un mensaje...",
                hintStyle: TextStyle(color: ColoresApp.colorSecundario, fontStyle: FontStyle.italic),
                fillColor: ColoresApp.colorApoyoIntenso,
                filled: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: ColoresApp.colorPrimario),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: ColoresApp.colorPrimarioIntenso, width: 2),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: onEnviar,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: ColoresApp.colorPrimarioIntenso,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.send, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}

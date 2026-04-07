import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase/componentes/titulo_artistico.dart';
import 'package:flutter_firebase/main.dart';
import 'package:flutter_firebase/servicios/servicio_auth.dart';
import 'package:flutter_firebase/utils/colores_app.dart';

class PaginaInicio extends StatefulWidget {
  const PaginaInicio({super.key});

  @override
  State<PaginaInicio> createState() => _PaginaInicioState();
}

class _PaginaInicioState extends State<PaginaInicio> {
  String? _fcmToken;

  @override
  void initState() {
    super.initState();
    _inicializarNotificaciones();
  }

  Future<void> _inicializarNotificaciones() async {
    final permitido = await servicioNotificaciones.solicitarPermisos();
    if (!permitido) return;

    final token = await servicioNotificaciones.obtenerYGuardarToken();
    if (mounted) setState(() => _fcmToken = token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColoresApp.colorApoyoIntenso,
        title: TituloArtistico(textoTitulo: "Conecta app"),
        actions: [
          IconButton(
            onPressed: () => ServicioAuth().logout(),
            icon: Icon(Icons.logout, color: ColoresApp.colorSecundario),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Token FCM (para pruebas):',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (_fcmToken != null) ...[
                SelectableText(
                  _fcmToken!,
                  style: const TextStyle(fontSize: 11),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: _fcmToken!));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Token copiado')),
                    );
                  },
                  icon: const Icon(Icons.copy),
                  label: const Text('Copiar token'),
                ),
              ] else
                const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

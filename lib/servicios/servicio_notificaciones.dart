import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// ---------------------------------------------------------------
// Manejador de mensajes en SEGUNDO PLANO / APP CERRADA
// OBLIGATORIO: debe ser una función de nivel superior (top-level),
// no puede ser un método de clase.
// ---------------------------------------------------------------
@pragma('vm:entry-point')
Future<void> _manejadorMensajeSegundoPlano(RemoteMessage mensaje) async {
  debugPrint('Mensaje en segundo plano: ${mensaje.messageId}');
  // FCM muestra la notificación automáticamente cuando la app está en
  // segundo plano o cerrada; no se necesita código adicional aquí.
}

class ServicioNotificaciones {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // Canal de Android — el id debe coincidir con el AndroidManifest.xml
  static const AndroidNotificationChannel _canal = AndroidNotificationChannel(
    'canal_principal',
    'Notificaciones',
    description: 'Canal principal de notificaciones de la aplicación',
    importance: Importance.high,
  );

  // ---------------------------------------------------------------
  // INICIALIZACIÓN PRINCIPAL
  // Llamar una sola vez desde main(), después de Firebase.initializeApp
  // ---------------------------------------------------------------
  Future<void> init() async {
    // 1. Registrar el manejador de segundo plano (debe ir antes de runApp)
    FirebaseMessaging.onBackgroundMessage(_manejadorMensajeSegundoPlano);

    // 2. Crear canal de notificaciones Android
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_canal);

    // 3. Inicializar flutter_local_notifications
    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    await _localNotifications.initialize(initSettings);

    // 4. Escuchar mensajes en PRIMER PLANO
    FirebaseMessaging.onMessage.listen(_mostrarNotificacionPrimerPlano);

    // 5. App abierta tocando notificación (app en segundo plano)
    FirebaseMessaging.onMessageOpenedApp.listen(_alAbrirNotificacion);

    // 6. App abierta tocando notificación (app cerrada)
    final mensajeInicial = await _fcm.getInitialMessage();
    if (mensajeInicial != null) _alAbrirNotificacion(mensajeInicial);

    debugPrint('ServicioNotificaciones inicializado');
  }

  // ---------------------------------------------------------------
  // SOLICITAR PERMISOS AL USUARIO
  // Llamar desde la UI después del login
  // ---------------------------------------------------------------
  Future<bool> solicitarPermisos() async {
    final ajustes = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    final permitido =
        ajustes.authorizationStatus == AuthorizationStatus.authorized ||
        ajustes.authorizationStatus == AuthorizationStatus.provisional;
    debugPrint('Permiso notificaciones: ${ajustes.authorizationStatus}');
    return permitido;
  }

  // ---------------------------------------------------------------
  // OBTENER TOKEN FCM Y GUARDARLO EN FIRESTORE
  // ---------------------------------------------------------------
  Future<String?> obtenerYGuardarToken() async {
    try {
      final token = await _fcm.getToken();
      if (token == null) return null;

      debugPrint('Token FCM: $token');
      await _guardarTokenEnFirestore(token);

      // Renovación automática del token (reinstalación, expiración, etc.)
      _fcm.onTokenRefresh.listen(_guardarTokenEnFirestore);

      return token;
    } catch (e) {
      debugPrint('Error al obtener token FCM: $e');
      return null;
    }
  }

  // ---------------------------------------------------------------
  // GUARDAR TOKEN EN FIRESTORE (campo adicional en usuarios/{uid})
  // ---------------------------------------------------------------
  Future<void> _guardarTokenEnFirestore(String token) async {
    final usuario = _auth.currentUser;
    if (usuario == null) return;

    // merge:true para no sobreescribir uid/email/nombre/fecha_registro
    await _firestore.collection('usuarios').doc(usuario.uid).set(
      {
        'fcm_token': token,
        'fcm_token_actualizado': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
    debugPrint('Token FCM guardado en Firestore (uid: ${usuario.uid})');
  }

  // ---------------------------------------------------------------
  // MOSTRAR NOTIFICACIÓN EN PRIMER PLANO
  // FCM no muestra nada visualmente con la app abierta;
  // flutter_local_notifications lo suple.
  // ---------------------------------------------------------------
  void _mostrarNotificacionPrimerPlano(RemoteMessage mensaje) {
    debugPrint('Mensaje en primer plano: ${mensaje.notification?.title}');
    final notif = mensaje.notification;
    if (notif == null) return;

    _localNotifications.show(
      notif.hashCode,
      notif.title,
      notif.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _canal.id,
          _canal.name,
          channelDescription: _canal.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------
  // CALLBACK AL ABRIR UNA NOTIFICACIÓN
  // ---------------------------------------------------------------
  void _alAbrirNotificacion(RemoteMessage mensaje) {
    debugPrint('Notificación abierta: ${mensaje.data}');
    // TODO: navegar a una pantalla específica según mensaje.data
  }
}

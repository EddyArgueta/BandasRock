import 'package:flutter/material.dart';
import 'package:bandasrock/Pantallas/pantalla_crea_bandas.dart';
import 'package:bandasrock/Pantallas/pantalla_listado.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart'; // Importa el paquete para manejar permisos

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Solicitar permiso de acceso a almacenamiento externo
  var status = await Permission.storage.request();
  if (status.isGranted) {
    print('Permiso de almacenamiento concedido.');
    runApp(MyApp());
  } else {
    print('Permiso de almacenamiento denegado.');
    // Mostrar un diálogo o pantalla explicando al usuario cómo activar el permiso manualmente
    // También puedes proporcionar un botón para abrir la configuración de la aplicación directamente
    await openAppSettings(); // Esta función abre la configuración de la aplicación en el dispositivo
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Votaciones de Bandas de Rock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', 
      routes: {
        '/': (context) => PantallaListadoBandas(), 
        '/crear': (context) => PantallaCreaBandas(), 
      },
    );
  }
}

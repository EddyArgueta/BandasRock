import 'package:flutter/material.dart';
import 'package:bandasrock/Pantallas/pantalla_crea_bandas.dart';
import 'package:bandasrock/Pantallas/pantalla_listado.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Votaciones de Bandas de Rock',
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PantallaCreaBandas extends StatefulWidget {
  @override
  _PantallaCreaBandasState createState() => _PantallaCreaBandasState();
}

class _PantallaCreaBandasState extends State<PantallaCreaBandas> {
  TextEditingController nombreController = TextEditingController();
  TextEditingController albumController = TextEditingController();
  TextEditingController yearController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Banda de Rock'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: 'Nombre de la banda'),
            ),
            TextField(
              controller: albumController,
              decoration: const InputDecoration(labelText: 'Nombre del álbum'),
            ),
            TextField(
              controller: yearController,
              decoration: const InputDecoration(labelText: 'Año de lanzamiento'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                //guardarBanda();
                Navigator.pop(context);
              },
              child: const Text('Guardar Banda'),
            ),
          ],
        ),
      ),
    );
  }
}


void guardarBanda(String nombre, String album, int year) async {
  CollectionReference bandas = FirebaseFirestore.instance.collection('bandas');
  await bandas.add({
    'nombre': nombre,
    'album': album,
    'year': year,
    'votos': 0, // Inicialmente empezara en 0
  });
}
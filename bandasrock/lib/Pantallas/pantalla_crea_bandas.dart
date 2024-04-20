import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PantallaCreaBandas extends StatefulWidget {
  @override
  _PantallaCreaBandasState createState() => _PantallaCreaBandasState();
}

class _PantallaCreaBandasState extends State<PantallaCreaBandas> {
  TextEditingController nombreController = TextEditingController();
  TextEditingController albumController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  File? _imageFile;

  Future<void> _getImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      setState(() {
        _imageFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _uploadImage(String id) async {
    if (_imageFile != null) {
      Reference ref = FirebaseStorage.instance.ref().child('bandas/$id/imagen');
      await ref.putFile(_imageFile!);
      String imageUrl = await ref.getDownloadURL();
      await FirebaseFirestore.instance.collection('colecciones').doc(id).update({'imagenUrl': imageUrl});
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Banda de Rock'),
      ),
      body: Container(
        color: Colors.white, // Color de fondo claro
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: nombreController,
                maxLength: 30,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'El nombre es obligatorio';
                  }
                  return null;
                },
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la Banda',
                  prefixIcon: Icon(Icons.group_outlined),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),
              TextFormField(
                controller: albumController,
                maxLength: 30,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'El nombre del Album es obligatorio';
                  }
                  return null;
                },
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  labelText: 'Nombre del Album',
                  prefixIcon: Icon(Icons.queue_music),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),
              TextFormField(
                controller: yearController,
                maxLength: 10,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'El Año de Lanzamiento es obligatorio';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Año de Lanzamiento',
                  prefixIcon: Icon(Icons.calendar_month_rounded),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  CollectionReference bandas = FirebaseFirestore.instance.collection('colecciones');
                  DocumentReference docRef = await bandas.add({
                    'NombreBanda': nombreController.text,
                    'NombreAlbum': albumController.text,
                    'AñoLanzamiento': int.tryParse(yearController.text) ?? 0,
                    'CantidadVotos': 0,
                  });
                  await _uploadImage(docRef.id);
                  Navigator.pop(context);
                },
                child: const Text('Guardar Banda'),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _getImage,
                child: const Text('Seleccionar Imagen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


void guardarBanda(String nombre, String album, int year) async {
  CollectionReference bandas = FirebaseFirestore.instance.collection('colecciones');
  await bandas.add({
    'NombreBanda': nombre,
    'NombreAlbum': album,
    'AñoLanzamiento': year,
    'CantidadVotos': 0, // Inicialmente empezara en 0
  });
}

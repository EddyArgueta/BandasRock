import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PantallaListadoBandas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de Bandas de Rock'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('colecciones').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final bandas = snapshot.data!.docs;
          return ListView.builder(
            itemCount: bandas.length,
            itemBuilder: (BuildContext context, int index) {
              var banda = bandas[index];
              return Dismissible(
                key: Key(banda.id), // Usa la ID del documento como clave
                onDismissed: (direction) {
                  eliminarBanda(banda.id);
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: ListTile(
                  title: Text(banda['NombreBanda']),
                  subtitle: Text('Álbum: ${banda['NombreAlbum']} - Año: ${banda['AñoLanzamiento']}'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      votarBanda(banda.id);
                    },
                    child: Text('Votar (${banda['CantidadVotos']})'),
                  ),           
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/crear');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void votarBanda(String id) async {
    CollectionReference bandas = FirebaseFirestore.instance.collection('bandas');
    DocumentSnapshot banda = await bandas.doc(id).get();
    int votosActuales = banda['CantidadVotos'];
    await bandas.doc(id).update({'CantidadVotos': votosActuales + 1});
  }

  void eliminarBanda(String id) async {
    CollectionReference bandas = FirebaseFirestore.instance.collection('bandas');
    await bandas.doc(id).delete();
  }
}

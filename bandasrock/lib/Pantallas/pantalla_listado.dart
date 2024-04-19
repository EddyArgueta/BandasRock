import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PantallaListadoBandas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listado de Bandas de Rock'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('bandas').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final bandas = snapshot.data!.docs;
          return ListView.builder(
            itemCount: bandas.length,
            itemBuilder: (BuildContext context, int index) {
              var banda = bandas[index];
              return ListTile(
                title: Text(banda['nombre']),
                subtitle: Text('Álbum: ${banda['album']} - Año: ${banda['year']}'),
                trailing: ElevatedButton(
                  onPressed: () {
                    votarBanda(banda.id);
                  },
                  child: Text('Votar (${banda['votos']})'),
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
}

void votarBanda(String id) async {
  CollectionReference bandas = FirebaseFirestore.instance.collection('bandas');
  DocumentSnapshot banda = await bandas.doc(id).get();
  int votosActuales = banda['votos'];
  await bandas.doc(id).update({'votos': votosActuales + 1});
}

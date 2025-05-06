import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransporteursDisponiblesPage extends StatefulWidget {
  @override
  _TransporteursDisponiblesPageState createState() =>
      _TransporteursDisponiblesPageState();
}

class _TransporteursDisponiblesPageState
    extends State<TransporteursDisponiblesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Liste des transporteurs disponibles
  List<Map<String, dynamic>> availableTransporters = [];

  @override
  void initState() {
    super.initState();
    _loadAvailableTransporters();
  }

  // Charger les transporteurs disponibles
  Future<void> _loadAvailableTransporters() async {
    try {
      final querySnapshot = await _firestore
          .collection('transporteurs')
          .where('disponibilite', isEqualTo: true)
          .get();

      // Mettre à jour la liste avec les transporteurs disponibles
      setState(() {
        availableTransporters =
            querySnapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      print("Erreur lors du chargement des transporteurs disponibles: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transporteurs Disponibles'),
        backgroundColor:
            Colors.green, // Utilise la couleur verte pour les dispo
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: availableTransporters.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: availableTransporters.length,
                itemBuilder: (context, index) {
                  final transporter = availableTransporters[index];
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(transporter['nom'] ?? 'Transporteur'),
                      subtitle: Text('Disponible pour les trajets'),
                      leading: Icon(Icons.directions_car),
                      trailing: Icon(Icons.check_circle, color: Colors.green),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

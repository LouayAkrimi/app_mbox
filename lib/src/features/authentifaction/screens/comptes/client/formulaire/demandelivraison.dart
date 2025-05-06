import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DeliveryRequestForm extends StatelessWidget {
  final String truckId;
  final LatLng pointA;
  final LatLng pointB;
  final double distance;

  DeliveryRequestForm({
    required this.truckId,
    required this.pointA,
    required this.pointB,
    required this.distance,
  });

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Demande de livraison")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text("Camion ID: $truckId"),
              Text("Départ: ${pointA.latitude}, ${pointA.longitude}"),
              Text("Arrivée: ${pointB.latitude}, ${pointB.longitude}"),
              Text("Distance: ${distance.toStringAsFixed(2)} km"),
              TextFormField(
                controller: _descriptionController,
                decoration:
                    InputDecoration(labelText: "Description de la livraison"),
                validator: (value) => value == null || value.isEmpty
                    ? "Entrez une description"
                    : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Envoyer vers le backend ici
                    // Exemple : HTTP POST vers "/api/demandes"
                    print("Demande envoyée");
                    Navigator.pop(context);
                  }
                },
                child: Text("Envoyer la demande"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

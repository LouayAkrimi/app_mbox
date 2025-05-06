import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_application_m3awda/src/constants/colors.dart';
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/comptes/client/formulaire/demandelivraison.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  LatLng? _pointA;
  LatLng? _pointB;
  double? _distance;

  LatLng _currentLocation = const LatLng(36.8065, 10.1815); // Position initiale

  void _onMapCreated(GoogleMapController controller) {}

  double _calculateDistance(LatLng p1, LatLng p2) {
    const double R = 6371; // Rayon de la Terre en km
    double dLat = _degToRad(p2.latitude - p1.latitude);
    double dLon = _degToRad(p2.longitude - p1.longitude);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(p1.latitude)) *
            cos(_degToRad(p2.latitude)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _degToRad(double deg) => deg * (pi / 180);

  void _onTap(LatLng tappedPoint) {
    setState(() {
      if (_pointA == null) {
        _pointA = tappedPoint;
        _markers.add(
          Marker(
            markerId: const MarkerId('Point A'),
            position: _pointA!,
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            infoWindow: const InfoWindow(title: "Point A"),
          ),
        );
      } else if (_pointB == null) {
        _pointB = tappedPoint;
        _markers.add(
          Marker(
            markerId: const MarkerId('Point B'),
            position: _pointB!,
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            infoWindow: const InfoWindow(title: "Point B"),
          ),
        );

        _polylines.add(
          Polyline(
            polylineId: const PolylineId('Route'),
            visible: true,
            points: [_pointA!, _pointB!],
            width: 4,
            color: Colors.blue,
          ),
        );

        _distance = _calculateDistance(_pointA!, _pointB!);
      } else {
        // Reset
        _markers.clear();
        _polylines.clear();
        _pointA = tappedPoint;
        _pointB = null;
        _distance = null;
        _markers.add(
          Marker(
            markerId: const MarkerId('Point A'),
            position: _pointA!,
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            infoWindow: const InfoWindow(title: "Point A"),
          ),
        );
      }
    });
  }

  void _openFullScreenMap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenMapScreen(
          markers: _markers,
          polylines: _polylines,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 300,
            width: double.infinity,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _currentLocation,
                zoom: 8,
              ),
              markers: _markers,
              polylines: _polylines,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onTap: _onTap,
            ),
          ),
          const SizedBox(height: 10),
          if (_distance != null)
            Text(
              "Distance: ${_distance!.toStringAsFixed(2)} km",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Logique future de recherche
                  },
                  icon: const Icon(Icons.search, size: 20),
                  label:
                      const Text("Rechercher", style: TextStyle(fontSize: 13)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tPrimaryColor,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_pointA != null &&
                        _pointB != null &&
                        _distance != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DeliveryRequestForm(
                            truckId: 'Truck123',
                            pointA: _pointA!,
                            pointB: _pointB!,
                            distance: _distance!,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text("Sélectionnez deux points sur la carte")),
                      );
                    }
                  },
                  icon: const Icon(Icons.check, size: 20),
                  label: const Text("Réserver", style: TextStyle(fontSize: 13)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tPrimaryColor,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _openFullScreenMap,
                  icon: const Icon(Icons.map, size: 20),
                  label:
                      const Text("Plein écran", style: TextStyle(fontSize: 13)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tPrimaryColor,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5, // Exemple statique
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.local_shipping, size: 24),
                  title: Text('Transporteur ${index + 1}',
                      style: const TextStyle(fontSize: 15)),
                  subtitle: const Text(
                      'Distance: 2 km | Prix: 30 \$ | Véhicule: Van',
                      style: TextStyle(fontSize: 13)),
                  onTap: () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FullScreenMapScreen extends StatelessWidget {
  final Set<Marker> markers;
  final Set<Polyline> polylines;

  const FullScreenMapScreen({
    Key? key,
    required this.markers,
    required this.polylines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Carte en plein écran")),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(36.8065, 10.1815),
          zoom: 8,
        ),
        markers: markers,
        polylines: polylines,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}

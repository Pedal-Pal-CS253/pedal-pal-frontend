import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  bool _showInfoContainer = false;
  static const LatLng iitk = LatLng(26.5123, 80.2329);
  static const LatLng RM = LatLng(26.514345, 80.234805);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // Wrap with SingleChildScrollView
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          margin: EdgeInsets.only(top: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Hello, Raghav!',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20), // Add some space between text and GoogleMap
              Container(
                height: 600, // Adjust the height as needed
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(26.5113, 80.2329), // Assuming iitk coordinates
                    zoom: 13,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId('RM'),
                      position: RM,
                      infoWindow: InfoWindow(
                        title: 'Raghav Marker',
                        snippet: 'IIT Kanpur',
                      ),
                      onTap: (){
                        print('Raghav Marker');
                        setState(() {
                          _showInfoContainer = true;
                        });
                      },
                      icon: BitmapDescriptor.defaultMarker,
                    ),
                  },
                ),
              ),
              if (_showInfoContainer)
                Container(
                  width: 500,
                  height: 500,
                  color: Colors.blue,
                  child: Center(
                    child: Text(
                      'Additional Information',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

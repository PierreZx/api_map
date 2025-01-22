import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Map Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MeuAppMapsState(),
    );
  }
}

class MeuAppMapsState extends StatefulWidget {
  @override
  _MeuAppMapsStatecomander createState() => _MeuAppMapsStatecomander();
  
}

class _MeuAppMapsStatecomander extends State<MeuAppMapsState>{
  TextEditingController _latitudecontroller = TextEditingController();
  TextEditingController _longitude1controller = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
         appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 153, 252, 255),
          title: Center(
            child: Text("Geolocalização"))
          ),body:
          Column(
            children: [
                     TextField(
                      controller: _latitudecontroller,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: "Latitude",
                        filled: true,
                          border: OutlineInputBorder(
                          borderSide: BorderSide(width: 102),
                          borderRadius: BorderRadius.circular(20)
                          
                      
                        ),

                      ),
                     ),
                     TextField(
                      controller: _longitude1controller,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: "Longitude",
                        filled: true,
                          border: OutlineInputBorder(
                          borderSide: BorderSide(width: 102),
                          borderRadius: BorderRadius.circular(20)
                          
                      
                        ),

                      ),
                     ),
                     
                     IconButton(
                      onPressed: () {
                        String latitude = _latitudecontroller.text;
                        String longitude = _longitude1controller.text;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MapScreen(latitude, longitude),
                          ),
                        );
                      },
                      icon: Icon(Icons.location_on),
                    )
            ],
          )
    );
  }
}

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});
  final String latitude;
  final String longitude;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Map Example'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(51.509364, -0.128928), // Centro do mapa
          zoom: 8, // Nível de zoom inicial
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(51.509364, -0.128928),
                width: 40,
                height: 40,
                builder: (context) => const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

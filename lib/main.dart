import 'package:flutter/material.dart';
import 'package:osm_nominatim/osm_nominatim.dart';
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

class _MeuAppMapsStatecomander extends State<MeuAppMapsState> {
  TextEditingController _endcontroller = TextEditingController();
  double lat = 0.0;
  double lng = 0.0;

  Future<void> _getCoordinatesFromAddress(String endereco) async {
    try {
      final searchResult = await Nominatim.searchByName(
        query: endereco,
        limit: 1,
        addressDetails: true,
        extraTags: true,
        nameDetails: true,
      );

      if (searchResult.isNotEmpty) {
        final location = searchResult.first;
        setState(() {
          lat = location.lat;
          lng = location.lon;
        });
        print('Coordenadas encontradas: Lat: $lat, Lon: $lng');
         Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MapScreen(lat.toString(), lng.toString()),
          )
         );
      } else {
        print('Nenhum resultado encontrado para o endereço');
      }
    } catch (e) {
      print('Erro ao buscar coordenadas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 153, 252, 255),
        title: Center(child: Text("Geolocalização")),
      ),
      body: Column(
        children: [
          TextField(
            controller: _endcontroller,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: "Insira seu endereço",
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 102),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              String endereco = _endcontroller.text;
              if (endereco.isNotEmpty) {
                await _getCoordinatesFromAddress(endereco);
              } else {
                print('Por favor, insira um endereço válido');
              }
            },
            icon: Icon(Icons.location_on),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Erro'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}

class MapScreen extends StatelessWidget {
  final String latitude;
  final String longitude;

  const MapScreen(this.latitude, this.longitude, {super.key});

  @override
  Widget build(BuildContext context) {
    final double lat = double.tryParse(latitude) ?? 0.0;
    final double lng = double.tryParse(longitude) ?? 0.0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Map Example'),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(lat, lng),
          initialZoom: 13,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(lat, lng),
                width: 40,
                height: 40,
                child: Icon(
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

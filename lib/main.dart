import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;


void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PatientMapScreen(),
    );
  }
}


class PatientMapScreen extends StatefulWidget {
  const PatientMapScreen({super.key});


  @override
  State<PatientMapScreen> createState() => _PatientMapScreenState();
}


class _PatientMapScreenState extends State<PatientMapScreen> {
  String patientName = "Loading...";
  String patientId = "001"; //This comes from login
  final Map<String, Marker> _markers = {};
  LatLng _patientPos = const LatLng(41.8268, -71.4025); // Initial location: Brown University


  @override
  void initState() {
    super.initState();


    fetchPatientName();


    _markers[patientId] = Marker(
      markerId: MarkerId(patientId),
      position: _patientPos,
      infoWindow: InfoWindow(title: patientName),
    );


    Stream.periodic(const Duration(seconds: 10), (count) {
      return LatLng(
        _patientPos.latitude + 0.001 * count,
        _patientPos.longitude + 0.001 * count,
      );
    }).listen((newPos) {
      setState(() {
        _patientPos = newPos;
        _markers[patientId] =
            _markers[patientId]!.copyWith(positionParam: newPos);
      });

      updateBackend(newPos);
    });
  }


  Future<void> fetchPatientName() async {
    final url = Uri.parse('http://10.0.2.2:3000/patients/$patientId');
    final response = await http.get(url);


    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        patientName = data["name"];
        _markers[patientId] = _markers[patientId]!.copyWith(
          infoWindowParam: InfoWindow(title: patientName),
        );
      });
    }
  }




  Future<void> updateBackend(LatLng pos) async {
    final url = Uri.parse('http://10.0.2.2:3000/patients/001');


    await http.patch(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "latitude": pos.latitude,
        "longitude": pos.longitude,
        "lastUpdated": DateTime.now().toIso8601String(),
      }),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kapok – Real-Time Tracking Demo")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: _patientPos, zoom: 14),
        markers: _markers.values.toSet(),
      ),
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: FloatingActionButton.extended(
          onPressed: () {
            updateBackend(_patientPos);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Location Sent Immediately")),
            );
          },
          label: const Text("Send Location"),   // ⭐ TEXT HERE
          icon: const Icon(Icons.send),
          backgroundColor: Colors.blue,
        ),
      ),


    );
  }
}

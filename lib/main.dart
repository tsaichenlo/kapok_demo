import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of application.
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
  final Map<String, Marker> _markers = {};
  LatLng _patientPos = const LatLng(41.8268, -71.4025); // Initial location: Brown University

  @override
  void initState() {
    super.initState();

    // Initial marker
    _markers["patient1"] = Marker(
      markerId: const MarkerId("patient1"),
      position: _patientPos,
      infoWindow: const InfoWindow(title: "Patient 1"),
    );

    // Simulated backend updates (like Firebase stream)
    Stream.periodic(const Duration(seconds: 30), (count) {
      return LatLng(
        _patientPos.latitude + 0.001 * count,
        _patientPos.longitude + 0.001 * count,
      );
    }).listen((newPos) {
      setState(() {
        _patientPos = newPos;
        _markers["patient1"] =
            _markers["patient1"]!.copyWith(positionParam: newPos);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kapok – Real-Time Tracking Demo")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: _patientPos, zoom: 14),
        markers: _markers.values.toSet(),
      ),
    );
  }
}
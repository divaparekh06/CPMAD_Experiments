import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class UtilityHomeScreen extends StatefulWidget {
  const UtilityHomeScreen({super.key});

  @override
  State<UtilityHomeScreen> createState() => _UtilityHomeScreenState();
}

class _UtilityHomeScreenState extends State<UtilityHomeScreen> {
  // 1. Camera & Gallery Image State
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  // 2. Accelerometer Sensor State (Streams)
  double _x = 0.0, _y = 0.0, _z = 0.0;
  StreamSubscription<AccelerometerEvent>? _sensorSubscription;

  // 3. Location State (GPS)
  String _locationMessage = 'Tap "Get Location" to fetch GPS coordinates';
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    // Dynamically listen to accelerometer sensor events using Streams
    _sensorSubscription = accelerometerEventStream().listen((AccelerometerEvent event) {
      if (mounted) {
        setState(() {
          _x = event.x;
          _y = event.y;
          _z = event.z;
        });
      }
    });
  }

  @override
  void dispose() {
    _sensorSubscription?.cancel(); // Cancel stream subscription on screen close
    super.dispose();
  }

  // --- IMAGE PICKER (CAMERA / GALLERY) WITH RUNTIME PERMISSIONS ---
  Future<void> _pickImage(ImageSource source) async {
    // Check & request camera permission at runtime
    if (source == ImageSource.camera) {
      var status = await Permission.camera.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        _showErrorMessage('Camera permission was denied.');
        return;
      }
    }

    try {
      final XFile? photo = await _picker.pickImage(source: source);
      if (photo != null) {
        setState(() {
          _imageFile = File(photo.path); // Display / Replace selected image
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image loaded successfully!')),
        );
      }
    } catch (e) {
      _showErrorMessage('Error selecting image: $e');
    }
  }

  // --- GPS LOCATION WITH RUNTIME PERMISSIONS ---
  Future<void> _fetchGPSLocation() async {
    setState(() => _isLoadingLocation = true);

    try {
      // 1. Check if device location service is enabled
      bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) {
        _showErrorMessage('Location services are disabled. Please turn on GPS.');
        setState(() => _isLoadingLocation = false);
        return;
      }

      // 2. Check and request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showErrorMessage('Location permission was denied.');
          setState(() => _isLoadingLocation = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showErrorMessage('Location permission permanently denied. Enable in app settings.');
        setState(() => _isLoadingLocation = false);
        return;
      }

      // 3. Obtain current location coordinates
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _locationMessage =
            'Latitude: ${pos.latitude.toStringAsFixed(5)}\n'
            'Longitude: ${pos.longitude.toStringAsFixed(5)}\n'
            'Accuracy: ±${pos.accuracy.toStringAsFixed(1)} m';
        _isLoadingLocation = false;
      });
    } catch (e) {
      _showErrorMessage('Failed to fetch location: $e');
      setState(() => _isLoadingLocation = false);
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Utility App'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ------------------ CAMERA & GALLERY ------------------
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Camera & Gallery',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: _imageFile != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                _imageFile!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            )
                          : const Center(
                              child: Text(
                                'No image selected.\nUse buttons below to capture or pick.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _pickImage(ImageSource.camera),
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Camera'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _pickImage(ImageSource.gallery),
                          icon: const Icon(Icons.photo_library),
                          label: const Text('Gallery'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ------------------ ACCELEROMETER SENSOR ------------------
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Dynamic Accelerometer Stream',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _sensorValueBox('X', _x, Colors.red),
                        _sensorValueBox('Y', _y, Colors.green),
                        _sensorValueBox('Z', _z, Colors.blue),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ------------------ GPS LOCATION ------------------
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'GPS / Device Location',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _locationMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _isLoadingLocation
                        ? const CircularProgressIndicator()
                        : ElevatedButton.icon(
                            onPressed: _fetchGPSLocation,
                            icon: const Icon(Icons.my_location),
                            label: const Text('Get Location'),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sensorValueBox(String axis, double val, Color color) {
    return Column(
      children: [
        Text(
          '$axis-Axis',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 6),
        Text(
          val.toStringAsFixed(2),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Text('m/s²', style: TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

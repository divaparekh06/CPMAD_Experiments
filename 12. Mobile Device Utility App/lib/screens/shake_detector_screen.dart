import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class ShakeDetectorScreen extends StatefulWidget {
  const ShakeDetectorScreen({super.key});

  @override
  State<ShakeDetectorScreen> createState() => _ShakeDetectorScreenState();
}

class _ShakeDetectorScreenState extends State<ShakeDetectorScreen> {
  StreamSubscription<AccelerometerEvent>? _sensorSub;
  int _shakeCount = 0;
  String _statusText = 'Shake your device to test!';
  DateTime _lastShake = DateTime.now();

  // Typical threshold for shake detection (> 17.0 m/s^2)
  static const double shakeThreshold = 17.0;

  @override
  void initState() {
    super.initState();
    _sensorSub = accelerometerEventStream().listen((AccelerometerEvent event) {
      // Net Acceleration Magnitude = sqrt(x^2 + y^2 + z^2)
      double magnitude = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

      if (magnitude > shakeThreshold) {
        final now = DateTime.now();
        // Prevent continuous triggers with 500ms debounce
        if (now.difference(_lastShake).inMilliseconds > 500) {
          _lastShake = now;
          if (mounted) {
            setState(() {
              _shakeCount++;
              _statusText = '🎉 Shake Detected!';
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Device Shaken! Total Shakes: $_shakeCount'),
                duration: const Duration(seconds: 1),
                backgroundColor: Colors.teal,
              ),
            );
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _sensorSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shake Detector'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.vibration, size: 80, color: Colors.teal),
              const SizedBox(height: 20),
              Text(
                _statusText,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Shake Count: $_shakeCount',
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _shakeCount = 0;
                    _statusText = 'Shake your device to test!';
                  });
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Reset Count'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'screens/utility_home_screen.dart';
import 'screens/profile_photo_screen.dart';
import 'screens/shake_detector_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DeviceUtilityApp());
}

class DeviceUtilityApp extends StatelessWidget {
  const DeviceUtilityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Device Utility App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  
  final List<Widget> _screens = const [
    UtilityHomeScreen(),      // Core: Camera, Gallery, Accelerometer, GPS & Permissions
    ProfilePhotoScreen(),     // Post-Experiment Task 1: Update Profile Photo
    ShakeDetectorScreen(),    // Post-Experiment Task 2: Shake Detection Sensor
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.devices_other),
            label: 'Utilities',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle),
            label: 'Profile Photo',
          ),
          NavigationDestination(
            icon: Icon(Icons.vibration),
            label: 'Shake Detector',
          ),
        ],
      ),
    );
  }
}

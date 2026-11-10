import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final String gender;
  final List<String> skills;
  final int age;
  final bool notifications;

  const SuccessScreen({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.skills,
    required this.age,
    required this.notifications,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registration Successful')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Submitted Details:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Name: $name', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Email: $email', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Phone: $phone', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Gender: $gender', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Age: $age', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(
              'Skills: ${skills.isEmpty ? "None Selected" : skills.join(", ")}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Notifications: ${notifications ? "Enabled" : "Disabled"}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back to Form'),
            ),
          ],
        ),
      ),
    );
  }
}

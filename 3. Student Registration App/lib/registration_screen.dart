import 'package:flutter/material.dart';
import 'success_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Text Editing Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Radio button state for gender
  String _gender = 'Male';

  // Checkbox states for courses/skills
  bool _flutterSelected = false;
  bool _javaSelected = false;
  bool _pythonSelected = false;

  // Slider state for age
  double _age = 20.0;

  // Switch state for notification preferences
  bool _notificationsEnabled = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Gather selected skills
      List<String> skills = [];
      if (_flutterSelected) skills.add('Flutter');
      if (_javaSelected) skills.add('Java');
      if (_pythonSelected) skills.add('Python');

      // Navigate to success screen and pass data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SuccessScreen(
            name: _nameController.text,
            email: _emailController.text,
            phone: _phoneController.text,
            gender: _gender,
            skills: skills,
            age: _age.toInt(),
            notifications: _notificationsEnabled,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Registration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Email Field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty ||
                      !value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Phone Field
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.length < 10) {
                    return 'Please enter a valid 10-digit phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Password Field
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Gender Radio Buttons
              const Text(
                'Gender:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Male'),
                      value: 'Male',
                      groupValue: _gender,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (value) {
                        setState(() {
                          _gender = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Female'),
                      value: 'Female',
                      groupValue: _gender,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (value) {
                        setState(() {
                          _gender = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Course/Skill Checkboxes
              const Text(
                'Courses/Skills:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              CheckboxListTile(
                title: const Text('Defense Against The Dark Arts'),
                value: _flutterSelected,
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                onChanged: (bool? value) {
                  setState(() {
                    _flutterSelected = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Potions'),
                value: _javaSelected,
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                onChanged: (bool? value) {
                  setState(() {
                    _javaSelected = value ?? false;
                  });
                },
              ),

              const SizedBox(height: 10),

              // Age Slider
              Text(
                'Age: ${_age.toInt()}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Slider(
                value: _age,
                min: 15,
                max: 50,
                divisions: 35,
                label: _age.toInt().toString(),
                onChanged: (double value) {
                  setState(() {
                    _age = value;
                  });
                },
              ),
              const SizedBox(height: 10),

              // Switch Control
              SwitchListTile(
                title: const Text('Enable Email Notifications'),
                value: _notificationsEnabled,
                contentPadding: EdgeInsets.zero,
                onChanged: (bool value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

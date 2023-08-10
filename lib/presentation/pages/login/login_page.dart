import 'package:flutter/material.dart';
import 'package:hospital_flutter_app/data/repositories/patient_repository.dart';
import 'package:hospital_flutter_app/presentation/widgets/patient_list_widget.dart';
import 'package:hospital_flutter_app/data/api/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LoginPage extends StatelessWidget {
  final PatientRepository patientRepository;
  final ApiService apiService = ApiService(); // Instantiate your ApiService
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({required this.patientRepository}) : super();

  Future<void> _login(BuildContext context) async {
    final response = await apiService.post(
      '/login',
      {'username': _usernameController.text, 'password': _passwordController.text},
    );

    if (response.statusCode == 200) {
      final token = json.decode(response.body)['token'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PatientListWidget(patientRepository: patientRepository)),
      );
    } else {
     // Show login failed dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Login Failed'),
            content: const Text('Invalid username or password. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }    
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _login(context),
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
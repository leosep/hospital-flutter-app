// Import necessary packages and files
import 'package:flutter/material.dart'; // Flutter framework
import 'package:hospital_flutter_app/data/repositories/patient_repository.dart'; // PatientRepository class
import 'package:hospital_flutter_app/presentation/widgets/patient_list_widget.dart'; // PatientListWidget class
import 'package:hospital_flutter_app/data/api/api_services.dart'; // ApiService class
import 'package:shared_preferences/shared_preferences.dart'; // For working with local storage
import 'dart:convert'; // For handling JSON encoding/decoding

// Define a Flutter page for login
class LoginPage extends StatelessWidget {
  // Initialize the PatientRepository and ApiService
  final PatientRepository patientRepository;
  final ApiService apiService = ApiService();
  
  // Initialize controllers for text fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Constructor for the LoginPage
  LoginPage({required this.patientRepository}) : super();

  // Function to handle the login process
  Future<void> _login(BuildContext context) async {
    final response = await apiService.post(
      '/login',
      {'username': _usernameController.text, 'password': _passwordController.text},
    );

    if (response.statusCode == 200) {
      // If login is successful
      final token = json.decode(response.body)['token']; // Extract token from the response

      SharedPreferences prefs = await SharedPreferences.getInstance(); // Get an instance of shared preferences
      await prefs.setString('token', token); // Store the token in shared preferences

      // Navigate to the PatientListWidget after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PatientListWidget(patientRepository: patientRepository)),
      );
    } else {
      // If login fails, show a dialog
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
    // Build the UI for the login page
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
              onPressed: () => _login(context), // Trigger the login function when the button is pressed
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

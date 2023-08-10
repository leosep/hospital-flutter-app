// Import necessary packages
import 'package:flutter/material.dart'; // Flutter framework
import 'package:hospital_flutter_app/app.dart'; // Main application widget
import 'package:hospital_flutter_app/data/api/api_services.dart'; // ApiService class
import 'package:hospital_flutter_app/data/repositories/patient_repository.dart'; // PatientRepository class

// Create an instance of ApiService to handle API requests
final ApiService _apiService = ApiService();

// Create an instance of PatientRepository using the ApiService instance
final PatientRepository _patientRepository = PatientRepository(_apiService);

// The main entry point of the application
void main() {
  // Run the Flutter application by passing the PatientRepository instance to MyApp
  runApp(MyApp(patientRepository: _patientRepository));
}

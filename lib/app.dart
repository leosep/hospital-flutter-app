// Import necessary packages
import 'package:flutter/material.dart'; // Flutter framework
import 'package:hospital_flutter_app/data/repositories/patient_repository.dart'; // PatientRepository class
import 'package:hospital_flutter_app/routes.dart'; // AppRouter class for handling routes

// The main application widget
class MyApp extends StatelessWidget {
  final AppRouter _appRouter; // AppRouter instance to handle routing

  // Constructor to initialize MyApp with a PatientRepository instance
  MyApp({required PatientRepository patientRepository})
      : _appRouter = AppRouter(patientRepository: patientRepository), // Instantiate the AppRouter
        super();

  @override
  Widget build(BuildContext context) {
    // Build the MaterialApp widget that represents the app's structure and theming
    return MaterialApp(
      title: 'Hospital App', // App title
      theme: ThemeData(primarySwatch: Colors.blue), // App theme with primary color
      initialRoute: '/login', // Initial route when the app starts
      onGenerateRoute: _appRouter.generateRoute, // Define how to generate routes using AppRouter
    );
  }
}

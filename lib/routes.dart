// Import necessary packages
import 'package:flutter/material.dart'; // Flutter framework
import 'package:hospital_flutter_app/data/repositories/patient_repository.dart'; // PatientRepository class
import 'package:hospital_flutter_app/presentation/pages/login/login_page.dart'; // LoginPage class
import 'package:hospital_flutter_app/presentation/widgets/patient_list_widget.dart'; // PatientListWidget class
import 'package:hospital_flutter_app/presentation/widgets/patient_details_widget.dart'; // PatientDetailsWidget class
import 'package:hospital_flutter_app/presentation/widgets/add_patient_widget.dart'; // AddPatientWidget class
import 'package:hospital_flutter_app/presentation/widgets/edit_patient_widget.dart'; // EditPatientWidget class
import 'package:hospital_flutter_app/data/models/patient.dart'; // Patient class

// Class for managing app routing logic
class AppRouter {
  final PatientRepository patientRepository; // PatientRepository instance

  // Constructor to initialize AppRouter with a PatientRepository instance
  AppRouter({required this.patientRepository});

  // Function to generate routes based on route settings
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        // Return a MaterialPageRoute to the PatientListWidget for the root route '/'
        return MaterialPageRoute(
          builder: (context) => PatientListWidget(patientRepository: patientRepository),
        );
      case '/login':
        // Return a MaterialPageRoute to the LoginPage for the '/login' route
        return MaterialPageRoute(
          builder: (context) => LoginPage(patientRepository: patientRepository),
        );
      case '/patientDetails':
        final patient = settings.arguments as Patient; // Retrieve the patient argument
        // Return a MaterialPageRoute to the PatientDetailsWidget with the given patient
        return MaterialPageRoute(
          builder: (context) => PatientDetailsWidget(
            patient: patient,
            patientRepository: patientRepository,
          ),
        );
      case '/addPatient':
        // Return a MaterialPageRoute to the AddPatientWidget for the '/addPatient' route
        return MaterialPageRoute(
          builder: (context) => AddPatientWidget(patientRepository: patientRepository),
        );
      case '/editPatient':
        final patient = settings.arguments as Patient; // Retrieve the patient argument
        // Return a MaterialPageRoute to the EditPatientWidget with the given patient
        return MaterialPageRoute(
          builder: (context) => EditPatientWidget(patient: patient, patientRepository: patientRepository),
        );
      // Add more cases for other routes if needed
      default:
        throw Exception('Unknown route: ${settings.name}'); // Handle unknown routes
    }
  }
}

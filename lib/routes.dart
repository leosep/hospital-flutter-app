import 'package:flutter/material.dart';
import 'package:hospital_flutter_app/data/repositories/patient_repository.dart';
import 'package:hospital_flutter_app/presentation/pages/login/login_page.dart';
import 'package:hospital_flutter_app/presentation/widgets/patient_list_widget.dart';
import 'package:hospital_flutter_app/presentation/widgets/patient_details_widget.dart';
import 'package:hospital_flutter_app/presentation/widgets/add_patient_widget.dart';
import 'package:hospital_flutter_app/presentation/widgets/edit_patient_widget.dart';
import 'package:hospital_flutter_app/data/models/patient.dart';

class AppRouter {
  final PatientRepository patientRepository;

  AppRouter({required this.patientRepository});

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) => PatientListWidget(patientRepository: patientRepository),
        );
      case '/login':
        return MaterialPageRoute(
          builder: (context) => LoginPage(patientRepository: patientRepository),
        );
      case '/patientDetails':
        final patient = settings.arguments as Patient;
        return MaterialPageRoute(
          builder: (context) => PatientDetailsWidget(
            patient: patient,
            patientRepository: patientRepository,
          ),
        );
      case '/addPatient':
        return MaterialPageRoute(
          builder: (context) => AddPatientWidget(patientRepository: patientRepository),
        );
      case '/editPatient':
        final patient = settings.arguments as Patient;
        return MaterialPageRoute(
          builder: (context) => EditPatientWidget(patient: patient, patientRepository: patientRepository),
        );
      // Add more cases for other routes if needed
      default:
        throw Exception('Unknown route: ${settings.name}');
    }
  }
}

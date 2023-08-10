// Import necessary packages and files
import 'package:flutter/material.dart'; // Flutter framework
import 'package:hospital_flutter_app/data/repositories/patient_repository.dart'; // PatientRepository class
import 'package:hospital_flutter_app/data/models/patient.dart'; // Patient class
import 'package:hospital_flutter_app/presentation/widgets/edit_patient_widget.dart'; // EditPatientWidget class
import 'package:hospital_flutter_app/presentation/widgets/patient_list_widget.dart'; // PatientListWidget class
import 'package:shared_preferences/shared_preferences.dart'; // For working with local storage
import 'package:hospital_flutter_app/presentation/pages/login/login_page.dart'; // LoginPage class

// Widget for displaying patient details
class PatientDetailsWidget extends StatefulWidget {
  final Patient patient;
  final PatientRepository _patientRepository;

  // Constructor to initialize the PatientDetailsWidget with a Patient and a PatientRepository instance
  PatientDetailsWidget({Key? key, required this.patient, required PatientRepository patientRepository})
      : _patientRepository = patientRepository,
        super(key: key);

  @override
  _PatientDetailsWidgetState createState() => _PatientDetailsWidgetState();
}

class _PatientDetailsWidgetState extends State<PatientDetailsWidget> {
  // Function to delete a patient
  void _deletePatient(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance(); // Get an instance of shared preferences
    final token = prefs.getString('token'); // Retrieve the token from shared preferences

    if (token == null) {
      // If token is not available, navigate to the login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage(patientRepository: widget._patientRepository)),
      );
      return;
    }
    
    try {
      // Delete the patient through the repository
      await widget._patientRepository.deletePatient(widget.patient.id);

      Navigator.pop(context); // Return to the previous page
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PatientListWidget(patientRepository: widget._patientRepository)), // Navigate back to the PatientListPage
      );
    } catch (e) {
      // Show an error dialog if deleting the patient fails
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to delete patient.'),
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

  // Function to show the delete confirmation dialog
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Patient'),
          content: const Text('Are you sure you want to delete this patient?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deletePatient(context); // Call the delete function
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Build the UI for displaying patient details
    return Scaffold(
      appBar: AppBar(title: const Text('Patient Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Name: ${widget.patient.name}'),
            Text('Address: ${widget.patient.address}'),
            Text('PhoneNumber: ${widget.patient.phoneNumber}'),
            const SizedBox(height: 16.0), // Add space between details and buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditPatientWidget(patient: widget.patient, patientRepository: widget._patientRepository,),
                      ),
                    );
                  },
                  child: const Text('Edit'),
                ),
                const SizedBox(
                    width: 16.0), // Add space between edit and delete buttons
                ElevatedButton(
                  onPressed: () {
                    _showDeleteConfirmation(
                        context); // Show the confirmation dialog
                  },
                  child: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hospital_flutter_app/data/repositories/patient_repository.dart';
import 'package:hospital_flutter_app/data/models/patient.dart';
import 'package:hospital_flutter_app/presentation/widgets/edit_patient_widget.dart';
import 'package:hospital_flutter_app/presentation/widgets/patient_list_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hospital_flutter_app/presentation/pages/login/login_page.dart';

class PatientDetailsWidget extends StatefulWidget {
  final Patient patient;
  final PatientRepository _patientRepository;

  PatientDetailsWidget({Key? key, required this.patient, required PatientRepository patientRepository})
      : _patientRepository = patientRepository,
        super(key: key);

  @override
  _PatientDetailsWidgetState createState() => _PatientDetailsWidgetState();
}

class _PatientDetailsWidgetState extends State<PatientDetailsWidget> {
  void _deletePatient(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage(patientRepository: widget._patientRepository)),
      );
      return;
    }
    
    try {
      await widget._patientRepository.deletePatient(widget.patient.id);

      Navigator.pop(context); // Return to previous page
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PatientListWidget(patientRepository: widget._patientRepository,)), 
      );
    } catch (e) {
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

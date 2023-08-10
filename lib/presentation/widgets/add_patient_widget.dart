import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hospital_flutter_app/data/repositories/patient_repository.dart';
import 'package:hospital_flutter_app/data/models/patient.dart';
import 'package:hospital_flutter_app/utils/phone_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hospital_flutter_app/presentation/widgets/patient_list_widget.dart';
import '../pages/login/login_page.dart';

class AddPatientWidget extends StatefulWidget {
  final PatientRepository _patientRepository;

  AddPatientWidget({Key? key, required PatientRepository patientRepository})
      : _patientRepository = patientRepository,
        super(key: key);

  @override
  _AddPatientWidgetState createState() => _AddPatientWidgetState();
}

class _AddPatientWidgetState extends State<AddPatientWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  void _addPatient(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage(patientRepository: widget._patientRepository)),
      );
      return;
    }

    Patient patient = Patient(
        id: 0,
        name: _nameController.text,
        address: _addressController.text,
        phoneNumber: _phoneNumberController.text);

    try {
      await widget._patientRepository.addPatient(patient);
      Navigator.pop(context); // Return to previous page
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PatientListWidget(patientRepository: widget._patientRepository,)), // Navigate back to PatientListPage
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to add patient.'),
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
      appBar: AppBar(title: const Text('Add Patient')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            TextFormField(
              controller: _phoneNumberController,
              inputFormatters: [
                LengthLimitingTextInputFormatter(14), // Limit to 10 characters
                PhoneInputFormatter(), // Your phone number formatter
              ],
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _addPatient(context),
              child: const Text('Add Patient'),
            ),
          ],
        ),
      ),
    );
  }
}

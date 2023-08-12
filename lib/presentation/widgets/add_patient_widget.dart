// Import necessary packages and files
import 'package:flutter/material.dart'; // Flutter framework
import 'package:flutter/services.dart'; // For input formatters
import 'package:hospital_flutter_app/data/repositories/patient_repository.dart'; // PatientRepository class
import 'package:hospital_flutter_app/data/models/patient.dart'; // Patient class
import 'package:hospital_flutter_app/utils/phone_input_formatter.dart'; // Custom phone number input formatter
import 'package:shared_preferences/shared_preferences.dart'; // For working with local storage
import 'package:hospital_flutter_app/presentation/widgets/patient_list_widget.dart'; // PatientListWidget class
import 'package:hospital_flutter_app/presentation/pages/login/login_page.dart'; // LoginPage class

// Widget for adding a new patient
class AddPatientWidget extends StatefulWidget {
  final PatientRepository _patientRepository;

  // Constructor to initialize the AddPatientWidget with a PatientRepository instance
  AddPatientWidget({Key? key, required PatientRepository patientRepository})
      : _patientRepository = patientRepository,
        super(key: key);

  @override
  _AddPatientWidgetState createState() => _AddPatientWidgetState();
}

class _AddPatientWidgetState extends State<AddPatientWidget> {
  // Initialize controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  // Function to add a patient
  void _addPatient(BuildContext context) async {
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

    // Create a Patient object from the input data
    Patient patient = Patient(
        id: 0,
        name: _nameController.text,
        address: _addressController.text,
        phoneNumber: _phoneNumberController.text);

    try {
      // Add the patient through the repository
      await widget._patientRepository.addPatient(patient);
      Navigator.pop(context); // Return to the previous page
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PatientListWidget(patientRepository: widget._patientRepository)), // Navigate back to the PatientListPage
      );
    } catch (e) {
      // Show an error dialog if adding the patient fails
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
    // Build the UI for adding a new patient
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
                LengthLimitingTextInputFormatter(14), // Limit phone number to 14 characters
                PhoneInputFormatter(), // Apply phone number formatting
              ],
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _addPatient(context), // Trigger the addPatient function when the button is pressed
              child: const Text('Add Patient'),
            ),
          ],
        ),
      ),
    );
  }
}

// Import necessary packages and files
import 'package:flutter/material.dart'; // Flutter framework
import 'package:flutter/services.dart'; // For input formatters
import 'package:hospital_flutter_app/data/repositories/patient_repository.dart'; // PatientRepository class
import 'package:hospital_flutter_app/data/models/patient.dart'; // Patient class
import 'package:hospital_flutter_app/utils/phone_input_formatter.dart'; // Custom phone number input formatter
import 'package:shared_preferences/shared_preferences.dart'; // For working with local storage
import 'package:hospital_flutter_app/presentation/widgets/patient_list_widget.dart'; // PatientListWidget class
import 'package:hospital_flutter_app/presentation/pages/login/login_page.dart'; // LoginPage class

// Widget for editing an existing patient
class EditPatientWidget extends StatefulWidget {
  final Patient patient;
  final PatientRepository _patientRepository;

  // Constructor to initialize the EditPatientWidget with a Patient and a PatientRepository instance
  EditPatientWidget(
      {Key? key,
      required this.patient,
      required PatientRepository patientRepository})
      : _patientRepository = patientRepository,
        super(key: key);

  @override
  _EditPatientWidgetState createState() => _EditPatientWidgetState(patient);
}

class _EditPatientWidgetState extends State<EditPatientWidget> {
  // Initialize controllers for text fields
  final TextEditingController _nameController;
  final TextEditingController _addressController;
  final TextEditingController _phoneNumberController;

  // Constructor for the state
  _EditPatientWidgetState(Patient patient)
      : _nameController = TextEditingController(text: patient.name),
        _addressController = TextEditingController(text: patient.address),
        _phoneNumberController = TextEditingController(text: patient.phoneNumber),
        super();

  // Function to update a patient
  void _updatePatient(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance(); // Get an instance of shared preferences
    final token = prefs.getString('token'); // Retrieve the token from shared preferences

    if (token == null) {
      // If token is not available, navigate to the login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage(patientRepository: widget._patientRepository)),
      );
      return;
    }

    // Create a new Patient object with updated information
    final patient = Patient(
      id: widget.patient.id,
      name: _nameController.text,
      address: _addressController.text,
      phoneNumber: _phoneNumberController.text,
    );

    try {
      // Update the patient through the repository
      await widget._patientRepository.updatePatient(patient);

      Navigator.pop(context); // Return to the previous page
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PatientListWidget(patientRepository: widget._patientRepository)), // Navigate back to the PatientListPage
      );
    } catch (e) {
      // Show an error dialog if updating the patient fails
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to update patient.'),
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
    // Build the UI for editing an existing patient
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Patient')),
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
              decoration: const InputDecoration(labelText: 'Adress'), // Typo: should be 'Address'
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
              onPressed: () => _updatePatient(context), // Trigger the updatePatient function when the button is pressed
              child: const Text('Update Patient'),
            ),
          ],
        ),
      ),
    );
  }
}

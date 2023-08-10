// Import necessary packages and files
import 'package:flutter/material.dart'; // Flutter framework
import 'package:hospital_flutter_app/data/models/patient.dart'; // Patient class
import 'package:hospital_flutter_app/data/repositories/patient_repository.dart'; // PatientRepository class
import 'package:hospital_flutter_app/presentation/widgets/patient_details_widget.dart'; // PatientDetailsWidget class
import 'package:hospital_flutter_app/presentation/widgets/add_patient_widget.dart'; // AddPatientWidget class
import 'package:shared_preferences/shared_preferences.dart'; // For working with local storage
import '../pages/login/login_page.dart'; // LoginPage class

// Widget for displaying a list of patients
class PatientListWidget extends StatefulWidget {
  final PatientRepository _patientRepository;

  // Constructor to initialize the PatientListWidget with a PatientRepository instance
  PatientListWidget({Key? key, required PatientRepository patientRepository})
      : _patientRepository = patientRepository,
        super(key: key);

  @override
  _PatientListWidgetState createState() => _PatientListWidgetState();
}

class _PatientListWidgetState extends State<PatientListWidget> {
  List<Patient> patients = [];
  int currentPage = 1;
  int pageSize = 10;

  @override
  void initState() {
    super.initState();
    fetchPatients(currentPage);
  }

  // Function to fetch patients from the repository
  Future<void> fetchPatients(int page) async {
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
      // Fetch patient data from the repository
      final patientData = await widget._patientRepository.fetchPatients(page, pageSize);
      setState(() {
        patients = patientData; // Update the patients list
      });
    } catch (e) {
      print('Failed to fetch patients: $e'); // Log error if fetching patients fails
    }
  }

  // Function to navigate to a different page of patients
  void _goToPage(int page) {
    if (page > 0) {
      setState(() {
        currentPage = page; // Update the current page
      });
      fetchPatients(currentPage); // Fetch patients for the updated page
    }
  }

  // Function to log out the user
  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // Get an instance of shared preferences
    await prefs.remove('token'); // Remove the token from shared preferences

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login', // Replace with your login route name
      (Route<dynamic> route) => false, // Remove all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    // Build the UI for displaying the list of patients
    return Scaffold(
      appBar: AppBar(title: const Text('Patient List')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: patients.length,
              itemBuilder: (context, index) {
                final patient = patients[index];
                return ListTile(
                  title: Text('Name: ${patient.name}'),
                  subtitle: Text(
                      'Address: ${patient.address} | Phone: ${patient.phoneNumber}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PatientDetailsWidget(patientRepository: widget._patientRepository, patient: patient,),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16.0), // Add space between patient list and pagination buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _goToPage(currentPage - 1),
                child: const Text('Previous'),
              ),
              const SizedBox(width: 16.0),
              ElevatedButton(
                onPressed: () => _goToPage(currentPage + 1),
                child: const Text('Next'),
              ),
            ],
          ),
          const SizedBox(
              height: 16.0), // Add space between pagination and logout buttons
          FloatingActionButton(
            onPressed: () => _logout(context), // Call the logout function
            child: const Icon(Icons.logout),
          ),
          const SizedBox(height: 16.0), // Add space below the buttons
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPatientWidget(patientRepository: widget._patientRepository,)),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

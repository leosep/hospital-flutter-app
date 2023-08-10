import 'package:flutter/material.dart';
import 'package:hospital_flutter_app/data/models/patient.dart';
import 'package:hospital_flutter_app/data/repositories/patient_repository.dart';
import 'package:hospital_flutter_app/presentation/widgets/patient_details_widget.dart';
import 'package:hospital_flutter_app/presentation/widgets/add_patient_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/login/login_page.dart';

class PatientListWidget extends StatefulWidget {
  final PatientRepository _patientRepository;

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

  Future<void> fetchPatients(int page) async {
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
      final patientData = await widget._patientRepository.fetchPatients(page, pageSize);
      setState(() {
        patients = patientData;
      });
    } catch (e) {
      print('Failed to fetch patients: $e');
    }
  }

  
  void _goToPage(int page) {
    if (page > 0) {
      setState(() {
        currentPage = page;
      });
      fetchPatients(currentPage);
    }
  }

  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login', // Replace with your login route name
      (Route<dynamic> route) => false, // Remove all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
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
          const SizedBox(height: 16.0),
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

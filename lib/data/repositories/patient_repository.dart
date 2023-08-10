// Import necessary packages and files
import 'package:hospital_flutter_app/data/api/api_services.dart'; // Import the ApiService class
import 'package:hospital_flutter_app/data/models/patient.dart'; // Import the Patient class
import 'dart:convert'; // For handling JSON encoding/decoding

// Repository class for managing patient data
class PatientRepository {
  final ApiService _apiService; // Instance of ApiService for API communication

  // Constructor to initialize the PatientRepository with an ApiService instance
  PatientRepository(this._apiService);

  // Function to fetch a list of patients from the API
  Future<List<Patient>> fetchPatients(int page, int pageSize) async {
    final response = await _apiService.get('/patients/$page/$pageSize'); // Get patient data from the API

    if (response.statusCode == 200) {
      // If the response status is successful (200)
      final List<dynamic> patientData = json.decode(response.body)['data']; // Extract patient data from JSON
      return patientData.map((data) => Patient.fromJson(data)).toList(); // Map patient data to Patient objects
    } else {
      throw Exception('Failed to fetch patients'); // Throw an exception if fetching fails
    }
  }

  // Function to add a new patient through the API
  Future<void> addPatient(Patient patient) async {
    final response = await _apiService.post('/patients', patient.toJson()); // Send patient data to the API

    if (response.statusCode != 201) {
      // If the response status is not successful (201)
      throw Exception('Failed to add patient'); // Throw an exception indicating failure
    }
  }

  // Function to update an existing patient through the API
  Future<void> updatePatient(Patient patient) async {
    final response = await _apiService.put('/patients/${patient.id}', patient.toJson()); // Send updated patient data to the API

    if (response.statusCode != 204) {
      // If the response status is not successful (204)
      throw Exception('Failed to update patient'); // Throw an exception indicating failure
    }
  }

  // Function to delete a patient through the API
  Future<void> deletePatient(int patientId) async {
    final response = await _apiService.delete('/patients/$patientId'); // Delete patient data through the API

    if (response.statusCode != 204) {
      // If the response status is not successful (204)
      throw Exception('Failed to delete patient'); // Throw an exception indicating failure
    }
  }
}

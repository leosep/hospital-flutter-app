import 'package:hospital_flutter_app/data/api/api_services.dart';
import 'package:hospital_flutter_app/data/models/patient.dart';
import 'dart:convert';

class PatientRepository {
  final ApiService _apiService;

  PatientRepository(this._apiService);

  Future<List<Patient>> fetchPatients(int page, int pageSize) async {
    final response = await _apiService.get('/patients/$page/$pageSize');

    if (response.statusCode == 200) {
      final List<dynamic> patientData = json.decode(response.body)['data'];
      return patientData.map((data) => Patient.fromJson(data)).toList();
    } else {
      throw Exception('Failed to fetch patients');
    }
  }

  Future<void> addPatient(Patient patient) async {
    final response = await _apiService.post('/patients', patient.toJson());

    if (response.statusCode != 201) {
      throw Exception('Failed to add patient');
    }
  }

  Future<void> updatePatient(Patient patient) async {
    final response = await _apiService.put('/patients/${patient.id}', patient.toJson());

    if (response.statusCode != 204) {
      throw Exception('Failed to update patient');
    }
  }

  Future<void> deletePatient(int patientId) async {
    final response = await _apiService.delete('/patients/$patientId');

    if (response.statusCode != 204) {
      throw Exception('Failed to delete patient');
    }
  }
}
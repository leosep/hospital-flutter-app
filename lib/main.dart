import 'package:flutter/material.dart';
import 'package:hospital_flutter_app/app.dart';
import 'package:hospital_flutter_app/data/api/api_services.dart';
import 'package:hospital_flutter_app/data/repositories/patient_repository.dart';

final ApiService _apiService = ApiService();
final PatientRepository _patientRepository = PatientRepository(_apiService);

void main() {
  runApp(MyApp(patientRepository: _patientRepository));
}
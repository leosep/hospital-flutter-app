import 'package:flutter/material.dart';
import 'package:hospital_flutter_app/data/repositories/patient_repository.dart';
import 'package:hospital_flutter_app/routes.dart';

class MyApp extends StatelessWidget { 
  final AppRouter _appRouter;

  MyApp({required PatientRepository patientRepository})
      : _appRouter = AppRouter(patientRepository: patientRepository),
        super();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hospital App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      onGenerateRoute: _appRouter.generateRoute,
    );
  }
}
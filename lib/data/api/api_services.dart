// Import necessary packages
import 'package:http/http.dart' as http;
import 'dart:convert'; // For handling JSON encoding/decoding
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hospital_flutter_app/config/config.dart'; // For working with local storage

// Define a class for API service
class ApiService {
  final String baseUrl = AppConfig.apiUrl; // Base URL for API

  // Function to send a POST request
  Future<http.Response> post(String path, dynamic body) async {
    final token = await _getToken(); // Get the authentication token
    final response = await http.post(
      Uri.parse('$baseUrl$path'), // Combine base URL and path
      headers: {
        'Content-Type': 'application/json', // Set request header for JSON content
        'Authorization': 'Bearer $token', // Include the token in the Authorization header
      },
      body: json.encode(body), // Encode the request body as JSON
    );
    return response; // Return the response
  }

  // Function to send a GET request
  Future<http.Response> get(String path) async {
    final token = await _getToken(); // Get the authentication token
    final response = await http.get(
      Uri.parse('$baseUrl$path'), // Combine base URL and path
      headers: {'Authorization': 'Bearer $token'}, // Include the token in the Authorization header
    );
    return response; // Return the response
  }

  // Function to send a DELETE request
  Future<http.Response> delete(String path) async {
    final token = await _getToken(); // Get the authentication token
    final response = await http.delete(
      Uri.parse('$baseUrl$path'), // Combine base URL and path
      headers: {'Authorization': 'Bearer $token'}, // Include the token in the Authorization header
    );
    return response; // Return the response
  }

  // Function to send a PUT request
  Future<http.Response> put(String path, dynamic body) async {
    final token = await _getToken(); // Get the authentication token
    final response = await http.put(
      Uri.parse('$baseUrl$path'), // Combine base URL and path
      headers: {
        'Content-Type': 'application/json', // Set request header for JSON content
        'Authorization': 'Bearer $token', // Include the token in the Authorization header
      },
      body: json.encode(body), // Encode the request body as JSON
    );
    return response; // Return the response
  }

  // Private function to get the authentication token from shared preferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance(); // Get an instance of shared preferences
    return prefs.getString('token'); // Retrieve and return the token
  }
}

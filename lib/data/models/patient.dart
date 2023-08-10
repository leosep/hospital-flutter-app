// Define a class called Patient
class Patient {
  // Define properties for the patient
  final int id; // Patient's ID
  final String name; // Patient's name
  final String address; // Patient's address
  final String phoneNumber; // Patient's phone number

  // Constructor for the Patient class
  Patient({
    required this.id, // Initialize ID property (required)
    required this.name, // Initialize name property (required)
    required this.address, // Initialize address property (required)
    required this.phoneNumber, // Initialize phone number property (required)
  });

  // Convert Patient object to a JSON representation
  Map<String, dynamic> toJson() {
    return {
      'id': id, // Map ID property to 'id' key in JSON
      'name': name, // Map name property to 'name' key in JSON
      'address': address, // Map address property to 'address' key in JSON
      'phoneNumber': phoneNumber, // Map phone number property to 'phoneNumber' key in JSON
    };
  }

  // Factory constructor to create a Patient object from JSON data
  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'], // Extract 'id' value from JSON and assign to id property
      name: json['name'], // Extract 'name' value from JSON and assign to name property
      address: json['address'], // Extract 'address' value from JSON and assign to address property
      phoneNumber: json['phoneNumber'], // Extract 'phoneNumber' value from JSON and assign to phoneNumber property
    );
  }
}

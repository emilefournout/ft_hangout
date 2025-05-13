class Contact {
  final int? id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final String address;

  Contact({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.address,
  });

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'] as int?,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      phoneNumber: map['phoneNumber'] as String,
      email: map['email'] as String,
      address: map['address'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address,
    };
  }
}

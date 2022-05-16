class UserModel {
  String firstName;
  String lastName;
  String email;
  String contactNumber;
  bool phoneNumberFlag;
  String role;
  bool isActive;
  bool accountSetup;
  var addresses = [];
  var emergencyContacts = [];
  Map medicalCard = {};
  bool passwordCreated;
  String tempPassword;
  bool availableForWork;
  var ambulances = [];
  Map currentLocation;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.contactNumber,
    required this.phoneNumberFlag,
    required this.role,
    required this.isActive,
    required this.accountSetup,
    required this.addresses,
    required this.emergencyContacts,
    required this.medicalCard,
    required this.passwordCreated,
    required this.tempPassword,
    required this.availableForWork,
    required this.ambulances,
    required this.currentLocation,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    UserModel user = UserModel(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      contactNumber: json['contactNumber'],
      phoneNumberFlag: json['phoneNumberFlag'],
      role: json['role'],
      isActive: json['isActive'],
      accountSetup: json['accountSetup'],
      addresses: json['addresses'],
      emergencyContacts: json['emergencyContacts'],
      medicalCard: json['medicalCard'],
      passwordCreated: json['passwordCreated'],
      tempPassword: json['tempPassword'],
      availableForWork: json['availableForWork'],
      ambulances: json['ambulances'],
      currentLocation: json['currentLocation'],
    );
    return user;
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'contactNumber': contactNumber,
      'phoneNumberFlag': phoneNumberFlag,
      'role': role,
      'isActive': isActive,
      'accountSetup': accountSetup,
      'addresses': addresses,
      'emergencyContacts': emergencyContacts,
      'medicalCard': medicalCard,
      'passwordCreated': passwordCreated,
      'tempPassword': tempPassword,
      'availableForWork': availableForWork,
      'ambulances': ambulances,
      'currentLocation': currentLocation,
    };
  }

  getName() {
    return '$firstName $lastName';
  }

  getFirstName() {
    return firstName;
  }

  setFirstName(String firstName) {
    this.firstName = firstName;
  }

  setLastName(String lastName) {
    this.lastName = lastName;
  }

  hasPhoneNumber() {
    if (role == 'Patient') {
      return contactNumber.isEmpty;
    } else {
      return phoneNumberFlag == false;
    }
  }

  setPhoneNumber(contactNumber) {
    this.contactNumber = contactNumber;
  }

  isSetup() {
    return accountSetup;
  }

  addEmergencyContact(emergencyContact) {
    emergencyContacts.add(emergencyContact);
  }

  getAge() {
    var date = DateTime.parse(medicalCard['dateOfBirth']);
    var now = DateTime.now();
    var age = now.difference(date).inDays;
    return age ~/ 365;
  }

  setAvailaleForWork(bool availableForWork) {
    this.availableForWork = availableForWork;
  }

  getAmbulancesLength() {
    return ambulances.length;
  }
}

class UserInfo {
  final String fullName;
  final String phoneNumber;
  final String address;

  UserInfo({
    required this.fullName,
    required this.phoneNumber,
    required this.address,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'address': address,
    };
  }

  // Create from Map
  factory UserInfo.fromMap(Map<String, dynamic> map) {
    return UserInfo(
      fullName: map['fullName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      address: map['address'] ?? '',
    );
  }

  // Check if user info is complete
  bool get isComplete {
    return fullName.isNotEmpty && phoneNumber.isNotEmpty && address.isNotEmpty;
  }
}

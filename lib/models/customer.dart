class Customer {
  int? id;
  String fullName;
  String phone;
  String email;
  String address;
  String imagePath;

  Customer({
    this.id,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.address,
    required this.imagePath,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'fullName': fullName,
    'phone': phone,
    'email': email,
    'address': address,
    'imagePath': imagePath,
  };

  factory Customer.fromMap(Map<String, dynamic> map) => Customer(
    id: map['id'],
    fullName: map['fullName'],
    phone: map['phone'],
    email: map['email'],
    address: map['address'],
    imagePath: map['imagePath'],
  );
}

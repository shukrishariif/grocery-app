// lib/models/address.dart
class Address {
  final String id;
  final String type;
  final String street;
  final String city;
  final String state;
  final String zipCode;

  Address({
    required this.id,
    required this.type,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
    };
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      type: json['type'],
      street: json['street'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zipCode'],
    );
  }

  Address copyWith({
    String? id,
    String? type,
    String? street,
    String? city,
    String? state,
    String? zipCode,
  }) {
    return Address(
      id: id ?? this.id,
      type: type ?? this.type,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
    );
  }
}

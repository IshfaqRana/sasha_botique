import 'package:sasha_botique/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required String id,
    required String email,
    required String firstName,
    required String lastName,
    required String address,
    required String country,
    required String state,
    required String city,
    required String phone,
    required String postCode,
  }) : super(id: id, email: email, firstName: firstName, lastName: lastName, address: address, country: country, state: state, city: city, phone: phone, postCode: postCode);
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      address: json['address'] ?? '',
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      phone: json['phone'] ?? '',
      postCode: json['postCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'address': address,
      'country': country,
      'state': state,
      'city': city,
      'phone': phone,
      'postCode': postCode,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? address,
    String? country,
    String? state,
    String? city,
    String? phone,
    String? postCode,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      address: address ?? this.address,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      phone: phone ?? this.phone,
      postCode: postCode ?? this.postCode,
    );
  }
}

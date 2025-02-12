import 'package:sasha_botique/features/auth/domain/entities/user.dart';

class UserModel extends User{


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


}
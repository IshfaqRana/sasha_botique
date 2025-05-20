// To parse this JSON data, do
//
//     final updatedAccountResponseModel = updatedAccountResponseModelFromJson(jsonString);

import 'dart:convert';

UpdatedAccountResponseModel updatedAccountResponseModelFromJson(String str) => UpdatedAccountResponseModel.fromJson(json.decode(str));

String updatedAccountResponseModelToJson(UpdatedAccountResponseModel data) => json.encode(data.toJson());

class UpdatedAccountResponseModel {
  bool? status;
  int? statusCode;
  String? message;
  Payload? payload;

  UpdatedAccountResponseModel({
    this.status,
    this.statusCode,
    this.message,
    this.payload,
  });

  factory UpdatedAccountResponseModel.fromJson(Map<String, dynamic> json) => UpdatedAccountResponseModel(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    payload: json["payload"] == null ? null : Payload.fromJson(json["payload"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "payload": payload?.toJson(),
  };
}

class Payload {
  String? jwt;
  UpdatedAccount? updatedAccount;

  Payload({
    this.jwt,
    this.updatedAccount,
  });

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
    jwt: json["jwt"],
    updatedAccount: json["updatedAccount"] == null ? null : UpdatedAccount.fromJson(json["updatedAccount"]),
  );

  Map<String, dynamic> toJson() => {
    "jwt": jwt,
    "updatedAccount": updatedAccount?.toJson(),
  };
}

class UpdatedAccount {
  String? id;
  String? username;
  String? email;
  String? title;
  String? firstName;
  String? lastName;
  String? mobileNo;
  List<DeliveryAddress>? deliveryAddresses;
  bool? isBlacklisted;
  bool? isActive;
  bool? isDeleted;
  bool? isCreated;
  DateTime? createdAt;
  bool? isUpdated;
  DateTime? deletedAt;
  DateTime? updatedAt;
  int? v;
  List<PaymentMethod>? paymentMethod;

  UpdatedAccount({
    this.id,
    this.username,
    this.email,
    this.title,
    this.firstName,
    this.lastName,
    this.mobileNo,
    this.deliveryAddresses,
    this.isBlacklisted,
    this.isActive,
    this.isDeleted,
    this.isCreated,
    this.createdAt,
    this.isUpdated,
    this.deletedAt,
    this.updatedAt,
    this.v,
    this.paymentMethod,
  });

  factory UpdatedAccount.fromJson(Map<String, dynamic> json) => UpdatedAccount(
    id: json["_id"],
    username: json["username"],
    email: json["email"],
    title: json["title"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    mobileNo: json["mobile_no"],
    deliveryAddresses: json["delivery_addresses"] == null ? [] : List<DeliveryAddress>.from(json["delivery_addresses"]!.map((x) => DeliveryAddress.fromJson(x))),
    isBlacklisted: json["isBlacklisted"],
    isActive: json["isActive"],
    isDeleted: json["isDeleted"],
    isCreated: json["isCreated"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    isUpdated: json["isUpdated"],
    deletedAt: json["deletedAt"] == null ? null : DateTime.parse(json["deletedAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    paymentMethod: json["payment_method"] == null ? [] : List<PaymentMethod>.from(json["payment_method"]!.map((x) => PaymentMethod.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "username": username,
    "email": email,
    "title": title,
    "first_name": firstName,
    "last_name": lastName,
    "mobile_no": mobileNo,
    "delivery_addresses": deliveryAddresses == null ? [] : List<dynamic>.from(deliveryAddresses!.map((x) => x.toJson())),
    "isBlacklisted": isBlacklisted,
    "isActive": isActive,
    "isDeleted": isDeleted,
    "isCreated": isCreated,
    "createdAt": createdAt?.toIso8601String(),
    "isUpdated": isUpdated,
    "deletedAt": deletedAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "payment_method": paymentMethod == null ? [] : List<dynamic>.from(paymentMethod!.map((x) => x.toJson())),
  };
}

class DeliveryAddress {
  String? street;
  String? city;
  String? state;
  String? postalCode;
  String? country;
  bool? isDefault;
  String? addressLine1;
  String? fullName;
  String? phoneNumber;
  String? deliveryInstructions;
  dynamic addressLine2;

  DeliveryAddress({
    this.street,
    this.city,
    this.state,
    this.postalCode,
    this.country,
    this.isDefault,
    this.addressLine1,
    this.fullName,
    this.phoneNumber,
    this.deliveryInstructions,
    this.addressLine2,
  });

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) => DeliveryAddress(
    street: json["street"],
    city: json["city"],
    state: json["state"],
    postalCode: json["postal_code"],
    country: json["country"],
    isDefault: json["is_default"],
    addressLine1: json["address_line_1"],
    fullName: json["full_name"],
    phoneNumber: json["phone_number"],
    deliveryInstructions: json["delivery_instructions"],
    addressLine2: json["address_line_2"],
  );

  Map<String, dynamic> toJson() => {
    "street": street,
    "city": city,
    "state": state,
    "postal_code": postalCode,
    "country": country,
    "is_default": isDefault,
    "address_line_1": addressLine1,
    "full_name": fullName,
    "phone_number": phoneNumber,
    "delivery_instructions": deliveryInstructions,
    "address_line_2": addressLine2,
  };
}

class PaymentMethod {
  String? type;
  String? last4Digits;
  String? cardHolderName;
  String? expiryDate;
  String? country;
  bool? isDefault;

  PaymentMethod({
    this.type,
    this.last4Digits,
    this.cardHolderName,
    this.expiryDate,
    this.country,
    this.isDefault,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
    type: json["type"],
    last4Digits: json["last4_digits"],
    cardHolderName: json["card_holder_name"],
    expiryDate: json["expiry_date"],
    country: json["country"],
    isDefault: json["is_default"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "last4_digits": last4Digits,
    "card_holder_name": cardHolderName,
    "expiry_date": expiryDate,
    "country": country,
    "is_default": isDefault,
  };
}

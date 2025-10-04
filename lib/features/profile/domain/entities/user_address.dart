class UserAddress {
  String? street;
  String? name;
  String? city;
  String? state;
  String? postalCode;
  String? country;
  String? phone;
  String? instruction;
  bool? isDefault;

  UserAddress({
    this.street,
    this.name,
    this.city,
    this.state,
    this.postalCode,
    this.country,
    this.phone,
    this.instruction,
    this.isDefault,
  });

  // Check if two addresses are the same based on core fields
  bool isSameAs(UserAddress other) {
    return (street?.trim().toLowerCase() == other.street?.trim().toLowerCase()) &&
        (city?.trim().toLowerCase() == other.city?.trim().toLowerCase()) &&
        (postalCode?.trim().toLowerCase() == other.postalCode?.trim().toLowerCase()) &&
        (country?.trim().toLowerCase() == other.country?.trim().toLowerCase());
  }

}

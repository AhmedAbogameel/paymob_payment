part of 'paymob_payment.dart';

class PaymobBillingData {
  String? email;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? apartment;
  String? floor;
  String? street;
  String? building;
  String? postalCode;
  String? city;
  String? state;
  String? country;
  String? shippingMethod;

  PaymobBillingData({
    this.email,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.apartment,
    this.floor,
    this.street,
    this.building,
    this.postalCode,
    this.city,
    this.state,
    this.country,
    this.shippingMethod,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email ?? "Unknown",
      "first_name": firstName ?? "Unknown",
      "last_name": lastName ?? "Unknown",
      "phone_number": phoneNumber ?? "Unknown",
      "apartment": apartment ?? "NA",
      "floor": floor ?? "NA",
      "building": building ?? "NA",
      "street": street ?? "NA",
      "postal_code": postalCode ?? "NA",
      "city": city ?? "NA",
      "state": state ?? "NA",
      "country": country ?? "NA",
      "shipping_method": shippingMethod ?? "NA",
    };
  }

}
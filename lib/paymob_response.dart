part of 'paymob_payment.dart';

class PaymobResponse {
  bool success;
  String? transactionID;
  String? responseCode;
  String? message;

  PaymobResponse({
    this.transactionID,
    required this.success,
    this.responseCode,
    this.message,
  });

  factory PaymobResponse.fromJson(Map<String, dynamic> json) {
    return PaymobResponse(
      success: json['success'] == 'true',
      transactionID: json['id'],
      message: json['message'],
      responseCode: json['txn_response_code'],
    );
  }
}
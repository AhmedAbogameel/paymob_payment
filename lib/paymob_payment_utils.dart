part of 'paymob_payment.dart';

class PaymobPayment {
  static PaymobPayment instance = PaymobPayment();

  bool _isInitialized = false;

  final Dio _dio = Dio();
  final _baseURL = 'https://accept.paymob.com/api/';
  late String _apiKey;
  late int _integrationID;
  late int _iFrameID;
  late String _iFrameURL;
  late int _userTokenExpiration;

  Future<bool> initialize({
    required String apiKey,
    required  int integrationID,
    required  int iFrameID,
    int userTokenExpiration = 3600,
}) async {
    if (_isInitialized) {
      return true;
    }
    _dio.options.baseUrl = _baseURL;
    _dio.options.validateStatus = (status) => true;
    _apiKey = apiKey;
    _integrationID = integrationID;
    _iFrameID = iFrameID;
    _iFrameURL = 'https://accept.paymobsolutions.com/api/acceptance/iframes/$_iFrameID?payment_token=';
    _isInitialized = true;
    _userTokenExpiration = userTokenExpiration;
    return _isInitialized;
  }

  Future<String> _getAuthToken() async {
    try {
      final response = await _dio.post(
        'auth/tokens',
        data: {
          'api_key': _apiKey,
        },
      );
      return response.data['token'];
    } catch (e) {
      rethrow;
    }
  }

  Future<int> _addOrder({
    required String authToken,
    required String currency,
    required String amount,
  }) async {
    try {
      final response = await _dio.post(
        'ecommerce/orders',
        data: {
          "auth_token": authToken,
          "delivery_needed": "false",
          "amount_cents": amount,
          "currency": currency,
          "items": [],
        },
      );
      return response.data['id'];
    } catch (e) {
      rethrow;
    }
  }

  Future<String> _getPurchaseToken({
    required String authToken,
    required String currency,
    required int orderID,
    required String amount,
  }) async {
    final response = await _dio.post(
      'acceptance/payment_keys',
      data: {
        "auth_token": authToken,
        "amount_cents": amount,
        "expiration": _userTokenExpiration,
        "order_id": orderID,
        "billing_data": {
          "apartment": "00000",
          "email": "example@mail.com",
          "floor": "000",
          "first_name": "Unknown",
          "street": "Unknown",
          "building": "00000",
          "phone_number": "+9612341234",
          "shipping_method": "Unknown",
          "postal_code": "00000",
          "city": "NA",
          "country": "NA",
          "last_name": "NA",
          "state": "NA"
        },
        "currency": currency,
        "integration_id": _integrationID,
        "lock_order_when_paid": "false"
      },
    );
    final message = response.data['message'];
    if (message != null) {
      throw Exception(message);
    }
    return response.data['token'];
  }

  Future<PaymobResponse?> pay({
    required BuildContext context,
    required String currency,
    required String amountInCents,
    void Function(PaymobResponse response)? onPayment,
  }) async {
    if (!_isInitialized) {
      throw Exception('PaymobPayment is not initialized call:`PaymobPayment.instance.initialize`');
    }
    final authToken = await _getAuthToken();
    final orderID = await _addOrder(
      authToken: authToken,
      currency: currency,
      amount: amountInCents,
    );
    final purchaseToken = await _getPurchaseToken(
      authToken: authToken,
      currency: currency,
      orderID: orderID,
      amount: amountInCents,
    );
    if (context.mounted) {
      final response = await PaymobIFrame.show(
        context: context,
        redirectURL: _iFrameURL + purchaseToken,
        onPayment: onPayment,
      );
      return response;
    }
    return null;
  }
}
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


  /// Initializing PaymobPayment instance.
  Future<bool> initialize({
    /// It is a unique identifier for the merchant which used to authenticate your requests calling any of Accept's API.
    /// from dashboard Select Settings -> Account Info -> API Key
    required String apiKey,
    /// from dashboard Select Developers -> Payment Integrations -> Online Card ID
    required  int integrationID,
    /// from paymob Select Developers -> iframes
    required  int iFrameID,
    /// The expiration time of this payment token in seconds. (The maximum is 3600 seconds which is an hour)
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

  /// Get authentication token, which is valid for one hour from the creation time.
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

  /// At this step, you will register an order to Accept's database, so that you can pay for it later using a transaction
  Future<int> _addOrder({
    required String authToken,
    required String currency,
    required String amount,
    required List items,
  }) async {
    try {
      final response = await _dio.post(
        'ecommerce/orders',
        data: {
          "auth_token": authToken,
          "delivery_needed": "false",
          "amount_cents": amount,
          "currency": currency,
          "items": items,
        },
      );
      return response.data['id'];
    } catch (e) {
      rethrow;
    }
  }

  /// At this step, you will obtain a payment_key token. This key will be used to authenticate your payment request. It will be also used for verifying your transaction request metadata.
  Future<String> _getPurchaseToken({
    required String authToken,
    required String currency,
    required int orderID,
    required String amount,
    required PaymobBillingData billingData,
  }) async {
    final response = await _dio.post(
      'acceptance/payment_keys',
      data: {
        "auth_token": authToken,
        "amount_cents": amount,
        "expiration": _userTokenExpiration,
        "order_id": orderID,
        "billing_data": billingData,
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

  /// Proceed to pay with only calling this function.
  /// Opens a WebView at Paymob redirectedURL to accept user payment info.
  Future<PaymobResponse?> pay({
    /// BuildContext for navigation to WebView
    required BuildContext context,
    /// Which Currency you would pay in.
    required String currency,
    /// Payment amount in cents EX: 20000 is an 200 EGP
    required String amountInCents,
    /// Optional Callback if you can use return result of pay function or use this callback
    void Function(PaymobResponse response)? onPayment,
    /// list of json objects contains the contents of the purchase.
    List? items,
    /// The billing data related to the customer related to this payment.
    PaymobBillingData? billingData
  }) async {
    if (!_isInitialized) {
      throw Exception('PaymobPayment is not initialized call:`PaymobPayment.instance.initialize`');
    }
    final authToken = await _getAuthToken();
    final orderID = await _addOrder(
      authToken: authToken,
      currency: currency,
      amount: amountInCents,
      items: items ?? [],
    );
    final purchaseToken = await _getPurchaseToken(
      authToken: authToken,
      currency: currency,
      orderID: orderID,
      amount: amountInCents,
      billingData: billingData ?? PaymobBillingData(),
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
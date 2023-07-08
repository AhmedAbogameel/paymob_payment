import 'package:flutter/material.dart';
import 'package:paymob_payment/paymob_payment.dart';

void main() {
  PaymobPayment.instance.initialize(
    apiKey: "ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2libUZ0WlNJNkltbHVhWFJwWVd3aUxDSndjbTltYVd4bFgzQnJJam8yT1RBMk56VjkuX3lZTklHVGkwVXBLTmVzdjh0Q0dxc0ZlTmVkNnJobGFid2RoUXlJNFFuMlBUZ2k1Q3VyaGFxbmt2SGlrbXo1enBzaUdxYmhiU0pDU3VCTzA4bGxpcFE=",
    integrationID: 3364826,
    iFrameID: 728907,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PaymentView(),
    );
  }
}

class PaymentView extends StatefulWidget {
  const PaymentView({super.key});

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  PaymobResponse? response;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paymob Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (response != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("Success ==> ${response?.success}"),
                  const SizedBox(height: 8),
                  Text("Transaction ID ==> ${response?.transactionID}"),
                  const SizedBox(height: 8),
                  Text("Message ==> ${response?.message}"),
                  const SizedBox(height: 8),
                  Text("Response Code ==> ${response?.responseCode}"),
                  const SizedBox(height: 16),
                ],
              ),
            ElevatedButton(
              child: const Text('Pay'),
              onPressed: () => PaymobPayment.instance.pay(
                context: context,
                currency: "EGP",
                amountInCents: "20000", // 200 EGP
                onPayment: (response) => setState(() => this.response = response),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

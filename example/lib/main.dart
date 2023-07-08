import 'package:flutter/material.dart';
import 'package:paymob_payment/paymob_payment.dart';

void main() {
  // Testing info do not use in your app
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
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Color(0xFF007aec),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(const Color(0xFF007aec)),
          )
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const PaymentView(),
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
        title: const Text('Paymob'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network('https://paymob.com/images/logoC.png'),
            const SizedBox(height: 24),
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
              child: const Text('Pay for 200 EGP'),
              onPressed: () => PaymobPayment.instance.pay(
                context: context,
                currency: "EGP",
                amountInCents: "20000",
                onPayment: (response) => setState(() => this.response = response),
              ),
            )
          ],
        ),
      ),
    );
  }
}

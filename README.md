# paymob_payment

Easily accept payments through Online Cards in your Flutter app with Paymob.

## :rocket: Installation

Add this to `dependencies` in your app's `pubspec.yaml`

```yaml
moyasar_payment : latest_version
```

## :hammer: Initialization

```dart
PaymobPayment.instance.initialize(
  apiKey: "", // from dashboard Select Settings -> Account Info -> API Key 
  integrationID: 123456, // from dashboard Select Developers -> Payment Integrations -> Online Card ID 
  iFrameID: 123456, // from paymob Select Developers -> iframes 
);
```

## :bookmark: Usage

```dart
final PaymobResponse? response = await PaymobPayment.instance.pay(
  context: context,
  currency: "EGP",
  amountInCents: "20000", // 200 EGP
  onPayment: (response) => setState(() => this.response = response), // Optional
)
```

## :incoming_envelope: PaymobResponse Explaining

| Variable      | Type    | Description          |
| ------------- |---------| -------------------- |
| success       | bool    | Indicates if the transaction was successful or not |
| transactionID | String? | The ID of the transaction |
| responseCode  | String? | The response code for the transaction |
| message       | String? | A brief message describing the transaction |


## :test_tube: Testing Cards

#### :white_check_mark: Successful payment

| Variable     | Description      |
|--------------|------------------|
| Card Number  | 5123456789012346 |
| Expiry Month | 12               |
| Expiry Year  | 30               |
| CVV          | 123              |

#### :negative_squared_cross_mark: Declined payment

Change cvv to 111 or expiry year to 20

> :pushpin: Note :
> May be you have to call paymob support to activate your test card 
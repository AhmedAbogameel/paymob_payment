#ifndef FLUTTER_PLUGIN_PAYMOB_PAYMENT_PLUGIN_H_
#define FLUTTER_PLUGIN_PAYMOB_PAYMENT_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace paymob_payment {

class PaymobPaymentPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  PaymobPaymentPlugin();

  virtual ~PaymobPaymentPlugin();

  // Disallow copy and assign.
  PaymobPaymentPlugin(const PaymobPaymentPlugin&) = delete;
  PaymobPaymentPlugin& operator=(const PaymobPaymentPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace paymob_payment

#endif  // FLUTTER_PLUGIN_PAYMOB_PAYMENT_PLUGIN_H_

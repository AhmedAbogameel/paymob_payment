#include "include/paymob_payment/paymob_payment_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "paymob_payment_plugin.h"

void PaymobPaymentPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  paymob_payment::PaymobPaymentPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}

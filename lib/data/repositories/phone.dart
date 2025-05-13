import 'package:flutter/services.dart';

class PhoneRepo {
  static const MethodChannel _channel = MethodChannel(
    'com.example.ft_hangout/phone',
  );

  static Future<void> callNumber(String phoneNumber) async {
    await _channel.invokeMethod('callNumber', {'phone': phoneNumber});
  }
}

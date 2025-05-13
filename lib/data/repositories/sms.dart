import 'package:flutter/services.dart';
import '../models/sms.dart';

class SmsRepo {
  static const MethodChannel _channel = MethodChannel('com.example.sms_reader');

  static Future<List<Sms>> getAllSms() async {
    try {
      final List<dynamic> smsList = await _channel.invokeMethod('getAllSMS');
      return smsList.map((smsJson) => Sms.fromJson(smsJson)).toList();
    } on PlatformException catch (e) {
      return [];
    }
  }

  static Future<void> sendSms(String phoneNumber, String content) async {
    await _channel.invokeMethod('sendSMS', {
      'phone': phoneNumber,
      'msg': content,
    });
  }
}

import 'package:sms_maintained/sms.dart';

class SMS {
  final String number;
  final String message;

  SMS(this.number, this.message);

  Future<SmsMessage> send() {
    SmsMessage smsMessage = SmsMessage(number, message);

    smsMessage.onStateChanged.listen((state) {
      if (state == SmsMessageState.Sent) {
        print("SMS to $number is sent!");
      } else if (state == SmsMessageState.Delivered) {
        print("SMS to $number is delivered!");
      } else if (state == SmsMessageState.Fail) {
        print("SMS to $number is failed!");
      }
    });

    return SmsSender().sendSms(smsMessage);
  }

  static List sendSMSs(List<SMS> smsList) {
    var results = [];

    for (var sms in smsList) {
      results.add(sms.send());
    }

    return results;
  }

  @override
  String toString() {
    return 'SMS{number: $number, message: $message}';
  }
}

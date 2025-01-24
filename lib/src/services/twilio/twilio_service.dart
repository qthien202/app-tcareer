import 'package:app_tcareer/src/configs/app_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class TwilioService {
  final TwilioFlutter twilioFlutter = TwilioFlutter(
    accountSid: "", // replace with Account SID
    authToken: "", // replace with Auth Token
    twilioNumber: "+84", // replace with Twilio Number(With country code)
  );

  Future<TwilioResponse> sendVerificationCode(String phoneNumber) async {
    TwilioResponse response = await twilioFlutter.sendVerificationCode(
        verificationServiceId: "",
        recipient: phoneNumber,
        verificationChannel: VerificationChannel.SMS);
    return response;
  }

  Future<TwilioResponse> verifyCode(
      {required String phoneNumber, required String code}) async {
    TwilioResponse response = await twilioFlutter.verifyCode(
        verificationServiceId: "", recipient: phoneNumber, code: code);
    return response;
  }
}

final twilioService = Provider((ref) => TwilioService());

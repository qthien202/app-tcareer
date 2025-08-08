enum TypeVerify {
  registerPhone,
  registerEmail,
  forgotPasswordPhone,
  forgotPasswordEmail
}

class VerifyOTP {
  String? phoneNumber;
  String? verificationId;
  String? email;
  String? password;
  TypeVerify type;
  VerifyOTP(
      {this.phoneNumber,
      this.verificationId,
      required this.type,
      this.email,
      this.password});
}

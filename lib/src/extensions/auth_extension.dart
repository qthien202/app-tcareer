extension AuthExtension on String {
  bool get isValidEmail {
    final emailRegExp = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );
    return emailRegExp.hasMatch(this);
  }

  // Kiểm tra số điện thoại
  bool get isValidPhoneNumber {
    final phoneRegExp = RegExp(
      r'^\+?[0-9]{7,15}$',
    );
    return phoneRegExp.hasMatch(this);
  }

  bool isEmailOrPhoneNumber() {
    return isValidEmail || isValidPhoneNumber;
  }
}

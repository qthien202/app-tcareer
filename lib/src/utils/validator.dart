class Validator {
  static String? serial(valueDy) {
    String value = valueDy ?? '';
    if (value.isEmpty) {
      return 'Vui lòng nhập mã serial';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Vui lòng nhập mã serial là số từ 0-9';
    }
    return null;
  }

  static String? pointCanEmpty(valueDy, {int? maxPoint, int? minPoint}) {
    String value = valueDy ?? '';
    if (value.isEmpty) {
      return null;
    }
    return point(valueDy, maxPoint: maxPoint, minPoint: minPoint);
  }

  static String? point(valueDy, {int? maxPoint, int? minPoint}) {
    String value = valueDy ?? '';
    if (value.isEmpty) {
      return 'Vui lòng nhập điểm';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Vui lòng nhập điểm là số từ 0-9';
    }
    if (null != maxPoint) {
      int point = int.parse(value);
      if (point > maxPoint) {
        return 'Vui lòng nhập điểm <=$maxPoint';
      }
    }
    if (null != minPoint) {
      int point = int.parse(value);
      if (point < minPoint) {
        return 'Vui lòng nhập điểm >=$minPoint';
      }
    }
    return null;
  }

  static String? tax(valueDy) {
    String value = valueDy ?? '';
    if (value.isEmpty) {
      return 'Vui lòng nhập mã số thuế';
    }
    return null;
  }

  static String? fullnameCompany(valueDy) {
    String value = valueDy ?? '';
    if (value.isEmpty) {
      return 'Vui lòng nhập tên công ty';
    }
    return null;
  }

  static String? fullnameCanEmpty(valueDy) {
    String value = valueDy ?? '';
    if (value.isEmpty) {
      return null;
    }
    return fullname(valueDy);
  }

  static String? firstName(valueDy) {
    String value = valueDy ?? '';
    if (value.isEmpty) {
      return "Vui lòng nhập họ";
    }
    if (value.length < 2) {
      return "Họ bắt đầu từ 2 ký tự trở lên";
    }
    return null;
  }

  static String? lastName(valueDy) {
    String value = valueDy ?? '';
    if (value.isEmpty) {
      return "Vui lòng nhập tên";
    }
    if (value.length < 2) {
      return "Tên bắt đầu từ 2 ký tự trở lên";
    }
    return null;
  }

  static String? emailCanEmpty(valueDy) {
    String value = valueDy ?? '';
    if (value.isEmpty) {
      return null;
    }
    return email(valueDy);
  }

  static String? productName(valueDy) {
    String value = valueDy ?? '';
    if (value.isEmpty) {
      return 'Vui lòng nhập tên sản phẩm';
    }
    return null;
  }

  static String? bank(valueDy) {
    String value = valueDy ?? '';
    if (value.isEmpty) {
      return 'Vui lòng nhập số tài khoản ngân hàng';
    }
    return null;
  }

  static String? bankName(valueDy) {
    String value = valueDy ?? '';
    if (value.isEmpty) {
      return 'Vui lòng nhập họ tên chủ tài khoản ngân hàng';
    }
    return null;
  }

  static String? address(valueDy) {
    String value = valueDy;
    if (value.isEmpty) {
      return 'Vui lòng nhập địa chỉ cụ thể';
    }
    return null;
  }

  static String? idCard(valueDy) {
    String value = valueDy;
    if (value.isEmpty) {
      return 'Vui lòng nhập số CMND/ CCCD';
    }
    if (value.length != 9 && value.length != 12) {
      return 'Vui lòng nhập đủ 9 hoặc 12 số CMND/ CCCD';
    }
    return null;
  }

  static String? email(valueDy) {
    String value = valueDy;
    if (value.isEmpty) {
      return 'Vui lòng nhập email';
    }
    if (!RegExp(r"^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$")
        .hasMatch(value)) {
      return 'Vui lòng nhập đúng email';
    }
    return null;
  }

  static String? emailOrPhoneNumber(value) {
    if (value.isEmpty) {
      return 'Vui lòng nhập email hoặc số điện thoại';
    }

    final emailRegExp =
        RegExp(r"^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$");

    final phoneRegExp =
        RegExp(r'^\+?[0-9]{7,15}$' // Có thể có dấu "+" và từ 7 đến 15 chữ số
            );

    if (!emailRegExp.hasMatch(value) && !phoneRegExp.hasMatch(value)) {
      return 'Vui lòng nhập đúng email hoặc số điện thoại hợp lệ';
    }

    return null;
  }

  static String? birthday(valueDy) {
    String value = valueDy ?? '';
    if (value.isEmpty) {
      return 'Vui lòng chọn ngày sinh';
    }
    if (!RegExp(r'\d{4}.\d{2}.\d{2}').hasMatch(value)) {
      return 'Vui lòng nhập ngày theo định dạng "yyyy-MM-dd"';
    }
    return null;
  }

  static String? birthdayVn(valueDy) {
    String value = valueDy ?? '';
    if (value.isEmpty) {
      return 'Vui lòng chọn ngày sinh';
    }
    if (!RegExp(r'\d{2}.\d{2}.\d{4}').hasMatch(value)) {
      return 'Vui lòng nhập ngày theo định dạng "dd/MM/yyyy"';
    }
    return null;
  }

  static String? birthdayVnCanEmpty(valueDy) {
    String value = valueDy ?? '';
    if (value.isEmpty) {
      return null;
    }
    return birthdayVn(valueDy);
  }

  static String? referralCode(valueDy) {
    String value = valueDy ?? '';
    if (value.isEmpty) {
      return 'Vui lòng nhập mã người giới thiệu';
    }
    return null;
  }

  static String? fullname(valueDy) {
    String value = valueDy ?? '';
    if (value.isEmpty) {
      return 'Vui lòng nhập họ và tên';
    }
    if (!RegExp(r'\w+').hasMatch(value)) {
      return 'Vui lòng nhập đúng họ và tên';
    }
    if (value.length < 5) {
      return 'Họ tên phải từ 5 kí tự trở lên';
    }
    return null;
  }

  static String? phone(valueDy) {
    String value = valueDy ?? '';
    if (value.isEmpty) {
      return 'Vui lòng nhập số điện thoại Việt Nam';
    }
    if (value.trim().length != 10) {
      return 'Vui lòng nhập đúng 10 số điện thoại';
    }
    if (!RegExp(r'^0?[3|5|7|8|9][0-9]{8}$').hasMatch(value)) {
      return 'Vui lòng nhập đúng số điện thoại Việt Nam';
    }
    return null;
  }

  static String? password(valueDy) {
    String value = valueDy ?? '';
    if (value.length < 8) {
      return 'Vui lòng nhập mật khẩu ít nhất 8 ký tự';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Vui lòng nhập ít nhất 1 ký tự thường';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Vui lòng nhập ít nhất 1 ký tự in hoa';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Vui lòng nhập ít nhất 1 số từ 0 đến 9';
    }
    if (!RegExp(r'[!"#$%&' "'" '()*+,-./:;<=>?@[\\]^_`{|}~]').hasMatch(value)) {
      return 'Vui lòng nhập ít nhất 1 ký tự đặc biệt';
    }
    return null;
  }

  static String? rePassword(valueDy, String rePassword) {
    String value = valueDy ?? '';
    if (value.isEmpty) {
      return 'Vui lòng xác nhận lại mật khẩu';
    }
    if (value != rePassword) {
      return 'Mật khẩu xác nhận không khớp';
    }
    return null;
  }
}

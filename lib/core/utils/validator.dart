import '../constants/strings.dart';

class AppValidator {
// validate email address
  static String? validateEmail(String? values) {
    if (values == null || values.isEmpty) {
      return AppStrings.requiredEmail;
    }

    // Regular expression for email validation
    if (!RegExp(r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$').hasMatch(values)) {
      return AppStrings.invalidEmail;
    }

    return null;
  }

// validate password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.requiredPassword;
    }

    // Check for minimum password length
    if (value.length < 6) {
      return AppStrings.passwordLength;
    }

    // Check for uppercase letters
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return AppStrings.containUppercase;
    }

    // Check for numbers
    if (!value.contains(RegExp(r'[0-9]'))) {
      return AppStrings.containNumber;
    }

    // Check for special characters
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return AppStrings.containSpecialCharacter;
    }

    return null;
  }
}

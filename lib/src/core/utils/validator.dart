import '../../config/routes/router.dart';
import 'extension.dart';

class AppValidator {
// validate email address
  static String? validateEmail(String? values) {
    if (values == null || values.isEmpty) {
      return rootNavigatorKey.currentContext!.loc.requiredEmail;
    }

    // Regular expression for email validation
    if (!RegExp(r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$').hasMatch(values)) {
      return rootNavigatorKey.currentContext!.loc.invalidEmail;
    }

    return null;
  }

// validate password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return rootNavigatorKey.currentContext!.loc.requiredPassword;
    }

    // Check for minimum password length
    if (value.length < 6) {
      return rootNavigatorKey.currentContext!.loc.passwordLength;
    }

    // Check for uppercase letters
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return rootNavigatorKey.currentContext!.loc.containUppercase;
    }

    // Check for numbers
    if (!value.contains(RegExp(r'[0-9]'))) {
      return rootNavigatorKey.currentContext!.loc.containNumber;
    }

    // Check for special characters
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return rootNavigatorKey.currentContext!.loc.containSpecialCharacter;
    }

    return null;
  }
}

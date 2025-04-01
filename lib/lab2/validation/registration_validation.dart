class RegistrationValidation {
  static String? validateEmail(String email) {
    final emailRegExp =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegExp.hasMatch(email)) {
      return 'Невірний формат електронної пошти';
    }
    return null;
  }

  static String? validateLogin(String login) {
    final loginRegExp = RegExp(r'^[a-zA-Z]+$');
    if (!loginRegExp.hasMatch(login)) {
      return 'Ім\'я має містити лише літери';
    }
    return null;
  }

  static String? validatePassword(String password) {
    if (password.length < 6) {
      return 'Пароль має бути не менше 6 символів';
    }
    return null;
  }
}

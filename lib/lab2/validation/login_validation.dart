class LoginValidation {
  static String? validateLogin(String login) {
    if (login.isEmpty) {
      return 'Логін не може бути порожнім';
    }
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Пароль не може бути порожнім';
    }
    if (password.length < 6) {
      return 'Пароль має бути не менше 6 символів';
    }
    return null;
  }
}

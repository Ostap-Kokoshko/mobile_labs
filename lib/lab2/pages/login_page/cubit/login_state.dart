class LoginState {
  final String login;
  final String password;

  LoginState({required this.login, required this.password});

  factory LoginState.initial() {
    return LoginState(login: '', password: '');
  }

  LoginState copyWith({String? login, String? password}) {
    return LoginState(
      login: login ?? this.login,
      password: password ?? this.password,
    );
  }
}

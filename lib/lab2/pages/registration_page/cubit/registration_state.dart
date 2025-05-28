class RegistrationState {
  final String email;
  final String login;
  final String password;

  RegistrationState({
    this.email = '',
    this.login = '',
    this.password = '',
  });

  RegistrationState copyWith({String? email, String? login, String? password}) {
    return RegistrationState(
      email: email ?? this.email,
      login: login ?? this.login,
      password: password ?? this.password,
    );
  }
}

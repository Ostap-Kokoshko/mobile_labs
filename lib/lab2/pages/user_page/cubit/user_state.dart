class ProfileState {
  final String login;
  final String email;

  ProfileState({required this.login, required this.email});

  ProfileState copyWith({String? login, String? email}) {
    return ProfileState(
      login: login ?? this.login,
      email: email ?? this.email,
    );
  }
}

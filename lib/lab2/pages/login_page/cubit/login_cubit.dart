import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/lab2/pages/login_page/cubit/login_state.dart';
import 'package:mobile_labs/lab2/storage/user_storage_secure.dart';

class LoginCubit extends Cubit<LoginState> {
  final UserStorageSecure _storage = UserStorageSecure();

  LoginCubit() : super(LoginState.initial());

  void updateLogin(String login) {
    emit(state.copyWith(login: login));
  }

  void updatePassword(String password) {
    emit(state.copyWith(password: password));
  }

  Future<void> submitLogin(
    void Function() onSuccess,
    void Function(String) onError,
  ) async {
    final userData = await _storage.getUserData();
    if (state.login == userData['login'] &&
        state.password == userData['password']) {
      await _storage.saveUserLoginStatus(true);
      onSuccess();
    } else {
      onError('Невірний логін або пароль');
    }
  }
}

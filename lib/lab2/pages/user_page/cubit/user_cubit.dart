import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/lab2/pages/user_page/cubit/user_state.dart';
import 'package:mobile_labs/lab2/storage/user_storage_secure.dart';


class ProfileCubit extends Cubit<ProfileState> {
  final UserStorageSecure _storage;

  ProfileCubit(this._storage) : super(ProfileState(login: '', email: '')) {
    loadUserData();
  }

  Future<void> loadUserData() async {
    final data = await _storage.getUserDataForChange();
    emit(ProfileState(login: data['login'] ?? '', email: data['email'] ?? ''));
  }

  Future<void> saveUserData(String login, String email) async {
    await _storage.saveUserDataForChange(email, login);
    emit(ProfileState(login: login, email: email));
  }

  Future<void> deleteAccount() async {
    await _storage.clearUserData();
  }
}

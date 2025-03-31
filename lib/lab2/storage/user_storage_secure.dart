import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_labs/lab2/storage/user_storage.dart';

class UserStorageSecure implements IUserStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  Future<void> saveUserData(String email, String login, String password) async {
    await _storage.write(key: 'email', value: email);
    await _storage.write(key: 'login', value: login);
    await _storage.write(key: 'password', value: password);
  }

  @override
  Future<void> saveUserDataForChange(String email, String login) async {
    await _storage.write(key: 'email', value: email);
    await _storage.write(key: 'login', value: login);
  }

  @override
  Future<Map<String, String>> getUserData() async {
    final String? email = await _storage.read(key: 'email');
    final String? login = await _storage.read(key: 'login');
    final String? password = await _storage.read(key: 'password');
    return {
      'email': email ?? '',
      'login': login ?? '',
      'password': password ?? '',
    };
  }

  @override
  Future<Map<String, String>> getUserDataForChange() async {
    final String? email = await _storage.read(key: 'email');
    final String? login = await _storage.read(key: 'login');
    return {
      'email': email ?? '',
      'login': login ?? '',
    };
  }

  @override
  Future<void> clearUserData() async {
    await _storage.delete(key: 'email');
    await _storage.delete(key: 'login');
    await _storage.delete(key: 'password');
  }

  Future<void> saveUserLoginStatus(bool isLoggedIn) async {
    await _storage.write(
      key: 'isLoggedIn',
      value: isLoggedIn ? 'true' : 'false',
    );
  }

  Future<String?> getUserLoginStatus() async {
    return await _storage.read(key: 'isLoggedIn');
  }

  Future<void> saveLockState(bool isLockActive) async {
    await _storage.write(
      key: 'isLockActive',
      value: isLockActive.toString(),
    );
  }

  Future<bool> getLockState() async {
    final String? lockState = await _storage.read(key: 'isLockActive');
    return lockState == 'true';
  }

  Future<void> saveSmokeState(bool isSmokeDetected) async {
    await _storage.write(
      key: 'isSmokeDetected',
      value: isSmokeDetected.toString(),
    );
  }

  Future<bool> getSmokeState() async {
    final String? smokeState = await _storage.read(key: 'isSmokeDetected');
    return smokeState == 'true';
  }
}

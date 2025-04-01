import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_labs/lab2/storage/user_storage.dart';

class UserStorageSecure implements IUserStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String emailKey = 'email';
  String loginKey = 'login';
  String passwordKey = 'password';
  String lockKey = 'isLockActive';
  String smokeKey = 'isSmokeDetected';
  String loggedInKey = 'isLoggedIn';

  @override
  Future<void> saveUserData(String email, String login, String password) async {
    await _storage.write(key: emailKey, value: email);
    await _storage.write(key: loginKey, value: login);
    await _storage.write(key: passwordKey, value: password);
  }

  @override
  Future<void> saveUserDataForChange(String email, String login) async {
    await _storage.write(key: emailKey, value: email);
    await _storage.write(key: loginKey, value: login);
  }

  @override
  Future<Map<String, String>> getUserData() async {
    final email = await _storage.read(key: emailKey);
    final login = await _storage.read(key: loginKey);
    final password = await _storage.read(key: passwordKey);
    return {
      'email': email ?? '',
      'login': login ?? '',
      'password': password ?? '',
    };
  }

  @override
  Future<Map<String, String>> getUserDataForChange() async {
    final email = await _storage.read(key: emailKey);
    final login = await _storage.read(key: loginKey);
    return {
      'email': email ?? '',
      'login': login ?? '',
    };
  }

  @override
  Future<void> clearUserData() async {
    await _storage.delete(key: emailKey);
    await _storage.delete(key: loginKey);
    await _storage.delete(key: passwordKey);
  }

  Future<void> saveUserLoginStatus(bool isLoggedIn) async {
    await _storage.write(
      key: loggedInKey,
      value: isLoggedIn ? 'true' : 'false',
    );
  }

  Future<String?> getUserLoginStatus() async {
    return await _storage.read(key: loggedInKey);
  }

  Future<void> saveLockState(bool isLockActive) async {
    await _storage.write(
      key: lockKey,
      value: isLockActive.toString(),
    );
  }

  Future<bool> getLockState() async {
    final lockState = await _storage.read(key: lockKey);
    return lockState == 'true';
  }

  Future<void> saveSmokeState(bool isSmokeDetected) async {
    await _storage.write(
      key: smokeKey,
      value: isSmokeDetected.toString(),
    );
  }

  Future<bool> getSmokeState() async {
    final smokeState = await _storage.read(key: smokeKey);
    return smokeState == 'true';
  }
}

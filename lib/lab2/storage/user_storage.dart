abstract class IUserStorage {
  Future<void> saveUserData(String email, String login, String password);
  Future<Map<String, String>> getUserData();
  Future<void> clearUserData();
  Future<Map<String, String>> getUserDataForChange();
  Future<void> saveUserDataForChange(String email, String login);
}

import 'package:firebase_auth/firebase_auth.dart';

import '../models/account.dart';
import 'db_helper.dart';

class AccountService {
  static final AccountService _singleton = AccountService._internal();
  static final DbHelper _dbHelper = DbHelper();

  factory AccountService() {
    return _singleton;
  }

  AccountService._internal();

  static Future<void> userRegister(String username, String email, String password, String imgUrl, bool isAdmin) async {
    await _dbHelper.registerUser(username, email, password, imgUrl, isAdmin);
  }

  static Future<void> userLogin(String email, String password) async {
    await _dbHelper.signInUser(email, password);
  }

  static Future<void> updateAccount(String userId, Account account) async {
    await _dbHelper.updateUserInfo(userId, account.toMap());
  }

  static Future<void> addOrderToUser(String userId, Map<String, dynamic> order) async{
    await _dbHelper.addOrderToUser(userId, order);
  }

  static Future<Account?> getAccountInfo(String userId) async {
    Map<String, dynamic> data = await _dbHelper.getUserInfo(userId);
    return data.isNotEmpty ? Account.fromMap(data) : null;
  }

  static Future<void> logout() async {
    await _dbHelper.signOutUser();
  }

  static Future<User?> getCurrentUser() async {
    return await _dbHelper.getCurrentUser();
  }
}
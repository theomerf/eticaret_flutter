import 'dart:async';
import 'package:alisverisproje/data/account_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/account.dart';

class AccountBloc {
  final _accountStreamController = StreamController<Account?>.broadcast();

  Stream<Account?> get getStream => _accountStreamController.stream;

  AccountBloc() {
    fetchCurrentUser();
  }

  Future<void> registerUser(String username, String email, String password, String imgUrl, bool isAdmin) async {
    await AccountService.userRegister(username, email, password, imgUrl, isAdmin);
    await fetchCurrentUser();
  }

  Future<bool> loginUser(String email, String password) async {
    try {
      await AccountService.userLogin(email, password);
      await fetchCurrentUser();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> fetchUserInfo(String userId) async {
    Account? account = await AccountService.getAccountInfo(userId);
    _accountStreamController.sink.add(account);
  }

  Future<void> updateUserInfo(String userId, Account account) async {
    await AccountService.updateAccount(userId, account);
    await fetchUserInfo(userId);
  }

  Future<void> addOrderToUser(String userId, Map<String, dynamic> order) async {
    await AccountService.addOrderToUser(userId, order);
    await fetchUserInfo(userId);
  }

  Future<void> logout() async {
    await AccountService.logout();
    _accountStreamController.sink.add(null);
  }

  Future<void> fetchCurrentUser() async {
    User? user = await AccountService.getCurrentUser();
    if (user != null) {
      await fetchUserInfo(user.uid);
    } else {
      _accountStreamController.sink.add(null);
    }
  }

  void dispose() {
    _accountStreamController.close();
  }
}

final userBloc = AccountBloc();

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:atm_terminal_test/model/owed.dart';

class Account {
  String accountName;
  double balance;
  Owed owed;
  double value;
  String message;
  String act;
  String param;
  bool? isLogin;

  Account({
    this.accountName = "",
    this.balance = 0,
    this.value = 0,
    this.message = "",
    this.act = "",
    this.param = "",
    this.isLogin = false,
  }) : owed = Owed();
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'owed.dart';

class AccountData {
  String name;
  double balance;
  Owed owed;
  AccountData({
    required this.name,
    required this.balance,
    required this.owed,
  });

  static List<AccountData> accountDataList = [
    AccountData(name: "Alice", balance: 0, owed: Owed()),
    AccountData(name: "Bob", balance: 0, owed: Owed())
  ];
}

import 'package:atm_terminal_test/model/account.dart';
import 'package:atm_terminal_test/model/account_data.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'action_command_event.dart';
part 'action_command_state.dart';

class ActionCommandBloc extends Bloc<ActionCommandEvent, ActionCommandState> {
  ActionCommandBloc() : super(ActionCommandInitialState()) {
    on<LoadAction>(_onLoadAction);
    on<UpdateAction>(_onUpdateAction);
  }

  void _onLoadAction(LoadAction event, Emitter<ActionCommandState> emit) {
    emit(ActionCommandLoadedState());
  }

  void _onUpdateAction(UpdateAction event, Emitter<ActionCommandState> emit) {
    final state = this.state;
    final account = event.account;
    if (state is ActionCommandLoadedState) {
      var isLogin = account.isLogin;
      // ignore: unnecessary_type_check
      switch (account.act.toLowerCase()) {
        case "login":
          var msg1 = "";
          var msg2 = "";
          var msg3 = "";
          var sumMsg = "";
          // ignore: dead_code
          if (isLogin!) {
            account.message = "You already logged in.\n";
            isLogin = true;
            account.isLogin = true;
            emit(ActionCommandLoadedState(account: account));
          } else {
            for (var i = 0; i < AccountData.accountDataList.length; i++) {
              if (account.param.toLowerCase() ==
                  AccountData.accountDataList[i].name.toLowerCase()) {
                account.accountName = account.param;
                msg1 =
                    "Hello, ${AccountData.accountDataList[i].name}! \n Your balance is \$ ${AccountData.accountDataList[i].balance}\n";
                sumMsg = "$msg1 ";

                if (AccountData.accountDataList[i].owed.balance > 0) {
                  msg2 =
                      " Owed \$${AccountData.accountDataList[i].owed.balance} ${AccountData.accountDataList[i].owed.fromTo} ${AccountData.accountDataList[i].owed.accountName}\n";
                  sumMsg = "$msg1 \n$msg2\n";
                }

                account.isLogin = true;
                sumMsg = "$msg1 $msg2";
                account.message = sumMsg;
                break;
              } else {
                account.message = "Your account is not registered!\n";
                isLogin = false;
              }
            }
            emit(ActionCommandLoadedState(account: account));
          }
          break;
        case "transfer":
          var msg1 = "";
          var msg2 = "";
          var msg3 = "";
          var msgSum = "";
          if (!isLogin!) {
            account.message = "Please login first";
            emit(ActionCommandLoadedState(account: account));
            // ignore: dead_code
          } else {
            account.accountName = account.accountName;
            var to = "";
            var valTrf = double.parse(account.param.split(" ")[1]);
            var isValid = false;

            var accData = AccountData.accountDataList.firstWhere((e) =>
                e.name.toLowerCase() == account.accountName.toLowerCase());
            account.accountName = accData.name;
            for (var i = 0; i < AccountData.accountDataList.length; i++) {
              if (account.param.split(" ")[0].toLowerCase() ==
                  AccountData.accountDataList[i].name.toLowerCase()) {
                to = AccountData.accountDataList[i].name;
                isValid = true;
                break;
              } else {
                msgSum = "Transfer destination not found\n";
                isValid = false;
              }
            }
            if (isValid) {
              //no owed
              if (accData.owed.accountName == "") {
                if (accData.balance > valTrf) {
                  // debit balance
                  AccountData.accountDataList
                      .firstWhere((e) =>
                          e.name.toLowerCase() == accData.name.toLowerCase())
                      .balance -= valTrf;
                  // credit balance
                  AccountData.accountDataList
                      .firstWhere(
                          (e) => e.name.toLowerCase() == to.toLowerCase())
                      .balance += valTrf;

                  msg1 = " Transferred \$$valTrf to $to";
                  msg2 =
                      " Your balance is \$${AccountData.accountDataList.firstWhere((e) => e.name.toLowerCase() == accData.name.toLowerCase()).balance}";
                  msgSum = "$msg1\n$msg2\n";
                } else {
                  var tempOwed = valTrf - accData.balance;
                  if (accData.balance > 0) {
                    var tempBal = AccountData.accountDataList
                        .firstWhere((e) =>
                            e.name.toLowerCase() == accData.name.toLowerCase())
                        .balance;
                    if ((tempBal - valTrf) < 0) {
                      //debit balance
                      AccountData.accountDataList
                          .firstWhere((e) =>
                              e.name.toLowerCase() ==
                              accData.name.toLowerCase())
                          .balance = 0;
                      //credit balance
                      AccountData.accountDataList
                          .firstWhere(
                              (e) => e.name.toLowerCase() == to.toLowerCase())
                          .balance += tempBal;

                      //owed
                      AccountData.accountDataList
                          .firstWhere((e) =>
                              e.name.toLowerCase() ==
                              accData.name.toLowerCase())
                          .owed
                          .balance += (tempOwed);
                      AccountData.accountDataList
                          .firstWhere((e) =>
                              e.name.toLowerCase() ==
                              accData.name.toLowerCase())
                          .owed
                          .accountName = to;

                      AccountData.accountDataList
                          .firstWhere((e) =>
                              e.name.toLowerCase() ==
                              accData.owed.accountName.toLowerCase())
                          .owed
                          .balance += (tempOwed);
                      AccountData.accountDataList
                          .firstWhere((e) =>
                              e.name.toLowerCase() ==
                              accData.owed.accountName.toLowerCase())
                          .owed
                          .accountName = accData.name;

                      AccountData.accountDataList
                          .firstWhere((e) =>
                              e.name.toLowerCase() ==
                              accData.owed.accountName.toLowerCase())
                          .owed
                          .fromTo = "from";

                      AccountData.accountDataList
                          .firstWhere((e) =>
                              e.name.toLowerCase() ==
                              accData.name.toLowerCase())
                          .owed
                          .fromTo = "to";

                      msg1 = " Transferred \$$tempBal to $to";
                      msg2 =
                          " Your balance is \$${AccountData.accountDataList.firstWhere((e) => e.name.toLowerCase() == accData.name.toLowerCase()).balance}";
                      msg3 =
                          " Owed \$${AccountData.accountDataList.firstWhere((e) => e.name.toLowerCase() == accData.name.toLowerCase()).owed.balance} ${AccountData.accountDataList.firstWhere((e) => e.name.toLowerCase() == accData.name.toLowerCase()).owed.fromTo} ${AccountData.accountDataList.firstWhere((e) => e.name.toLowerCase() == accData.name.toLowerCase()).owed.accountName}";
                      msgSum = "$msg1\n$msg2\n$msg3\n";
                    }
                  } else {
                    //owed
                    AccountData.accountDataList
                        .firstWhere((e) =>
                            e.name.toLowerCase() == accData.name.toLowerCase())
                        .owed
                        .balance += (valTrf);
                    AccountData.accountDataList
                        .firstWhere((e) =>
                            e.name.toLowerCase() == accData.name.toLowerCase())
                        .owed
                        .accountName = to;

                    AccountData.accountDataList
                        .firstWhere(
                            (e) => e.name.toLowerCase() == to.toLowerCase())
                        .owed
                        .balance += (valTrf);
                    AccountData.accountDataList
                        .firstWhere(
                            (e) => e.name.toLowerCase() == to.toLowerCase())
                        .owed
                        .accountName = account.accountName;

                    AccountData.accountDataList
                        .firstWhere(
                            (e) => e.name.toLowerCase() == to.toLowerCase())
                        .owed
                        .fromTo = "from";

                    AccountData.accountDataList
                        .firstWhere((e) =>
                            e.name.toLowerCase() == accData.name.toLowerCase())
                        .owed
                        .fromTo = "to";
                    msg1 = " Transferred \$$valTrf to $to";
                    msg2 =
                        " Your balance is \$${AccountData.accountDataList.firstWhere((e) => e.name.toLowerCase() == accData.name.toLowerCase()).balance}";
                    msg3 =
                        " Owed \$${AccountData.accountDataList.firstWhere((e) => e.name.toLowerCase() == accData.name.toLowerCase()).owed.balance} ${AccountData.accountDataList.firstWhere((e) => e.name.toLowerCase() == accData.name.toLowerCase()).owed.fromTo} ${AccountData.accountDataList.firstWhere((e) => e.name.toLowerCase() == accData.name.toLowerCase()).owed.accountName}";
                    msgSum = "$msg1\n$msg2\n$msg3\n";
                  }
                }
              } else {
                if (accData.owed.balance > valTrf) {
                  if (accData.owed.fromTo == "from") {
                    AccountData.accountDataList
                        .firstWhere((e) =>
                            e.name.toLowerCase() == accData.name.toLowerCase())
                        .owed
                        .balance -= valTrf;

                    AccountData.accountDataList
                        .firstWhere(
                            (e) => e.name.toLowerCase() == to.toLowerCase())
                        .owed
                        .balance -= valTrf;

                    msg1 = " Transferred \$$valTrf to $to";
                    msg2 =
                        " Your balance is \$${AccountData.accountDataList.firstWhere((e) => e.name.toLowerCase() == accData.name.toLowerCase()).balance}";
                    msg3 =
                        " Owed \$${AccountData.accountDataList.firstWhere((e) => e.name.toLowerCase() == accData.name.toLowerCase()).owed.balance} ${AccountData.accountDataList.firstWhere((e) => e.name.toLowerCase() == accData.name.toLowerCase()).owed.fromTo} ${AccountData.accountDataList.firstWhere((e) => e.name.toLowerCase() == accData.name.toLowerCase()).owed.accountName}";
                    msgSum = "$msg1\n$msg2\n$msg3\n";
                  } else {
                    AccountData.accountDataList
                        .firstWhere((e) =>
                            e.name.toLowerCase() == accData.name.toLowerCase())
                        .owed
                        .balance += valTrf;

                    AccountData.accountDataList
                        .firstWhere(
                            (e) => e.name.toLowerCase() == to.toLowerCase())
                        .owed
                        .balance += valTrf;

                    msg1 = " Transferred \$$valTrf to $to";
                    msg2 =
                        " Your balance is \$${AccountData.accountDataList.firstWhere((e) => e.name.toLowerCase() == accData.name.toLowerCase()).balance}";
                    msg3 =
                        " Owed \$${AccountData.accountDataList.firstWhere((e) => e.name.toLowerCase() == accData.name.toLowerCase()).owed.balance} ${AccountData.accountDataList.firstWhere((e) => e.name.toLowerCase() == accData.name.toLowerCase()).owed.fromTo} ${AccountData.accountDataList.firstWhere((e) => e.name.toLowerCase() == accData.name.toLowerCase()).owed.accountName}";
                    msgSum = "$msg1\n$msg2\n$msg3\n";
                  }
                } else {
                  if (accData.owed.fromTo == "from") {
                    var tempOwed = valTrf - accData.owed.balance;

                    AccountData.accountDataList
                        .firstWhere((e) =>
                            e.name.toLowerCase() == accData.name.toLowerCase())
                        .owed
                        .balance = 0;
                    AccountData.accountDataList
                        .firstWhere((e) =>
                            e.name.toLowerCase() == accData.name.toLowerCase())
                        .owed
                        .accountName = "";

                    AccountData.accountDataList
                        .firstWhere(
                            (e) => e.name.toLowerCase() == to.toLowerCase())
                        .owed
                        .balance = 0;
                    AccountData.accountDataList
                        .firstWhere(
                            (e) => e.name.toLowerCase() == to.toLowerCase())
                        .owed
                        .accountName = "";

                    AccountData.accountDataList
                        .firstWhere(
                            (e) => e.name.toLowerCase() == to.toLowerCase())
                        .owed
                        .fromTo = "";

                    AccountData.accountDataList
                        .firstWhere((e) =>
                            e.name.toLowerCase() == accData.name.toLowerCase())
                        .owed
                        .fromTo = "";

                    //debit rest values
                    AccountData.accountDataList
                        .firstWhere((e) =>
                            e.name.toLowerCase() == accData.name.toLowerCase())
                        .balance -= tempOwed;
                    //debit rest values
                    AccountData.accountDataList
                        .firstWhere(
                            (e) => e.name.toLowerCase() == to.toLowerCase())
                        .balance += tempOwed;

                    msg1 = " Transferred \$$valTrf to $to";
                    msg2 =
                        " Your balance is \$${AccountData.accountDataList.firstWhere((e) => e.name.toLowerCase() == accData.name.toLowerCase()).balance}";
                    msgSum = "$msg1\n$msg2\n";
                  } else {
                    AccountData.accountDataList
                        .firstWhere((e) =>
                            e.name.toLowerCase() == accData.name.toLowerCase())
                        .owed
                        .balance += valTrf;

                    AccountData.accountDataList
                        .firstWhere(
                            (e) => e.name.toLowerCase() == to.toLowerCase())
                        .owed
                        .balance += valTrf;

                    msg1 = " Transferred \$$valTrf to $to";
                    msg2 =
                        " Your balance is \$${AccountData.accountDataList.firstWhere((e) => e.name.toLowerCase() == accData.name.toLowerCase()).balance}";
                    msg3 =
                        " Owed \$${AccountData.accountDataList.firstWhere((e) => e.name.toLowerCase() == accData.name.toLowerCase()).owed.balance} ${AccountData.accountDataList.firstWhere((e) => e.name.toLowerCase() == accData.name.toLowerCase()).owed.fromTo} ${AccountData.accountDataList.firstWhere((e) => e.name.toLowerCase() == accData.name.toLowerCase()).owed.accountName}";
                    msgSum = "$msg1\n$msg2\n$msg3\n";
                  }
                }
              }
            }
            account.message = msgSum;
            emit(ActionCommandLoadedState(account: account));
          }
          break;
        case "deposit":
          if (!isLogin!) {
            account.message = "Please login first";
            emit(ActionCommandLoadedState(account: account));
            // ignore: dead_code
          } else {
            account.accountName = account.accountName;
            account.message = "Your balance is \$ ${account.balance}";
            var msg1 = "";
            var msg2 = "";
            var msg3 = "";
            var msgSum = "";

            var depVal = double.parse(account.param);

            var accData = AccountData.accountDataList.firstWhere((e) =>
                e.name.toLowerCase() == account.accountName.toLowerCase());
            if (accData.owed.accountName == "") {
              AccountData.accountDataList
                  .firstWhere((e) =>
                      e.name.toLowerCase() == account.accountName.toLowerCase())
                  .balance = depVal;

              msgSum =
                  "Your balance is \$ ${AccountData.accountDataList.firstWhere((e) => e.name.toLowerCase() == account.accountName.toLowerCase()).balance}\n";
            } else {
              var accTemp = AccountData.accountDataList.firstWhere((e) =>
                  e.name.toLowerCase() == account.accountName.toLowerCase());
              if (accTemp.owed.fromTo == "to") {
                var owedVal = AccountData.accountDataList
                    .firstWhere((e) =>
                        e.name.toLowerCase() ==
                        account.accountName.toLowerCase())
                    .owed
                    .balance;

                if (depVal > owedVal) {
                  var tempOwed = depVal - owedVal;

                  AccountData.accountDataList
                      .firstWhere((e) =>
                          e.name.toLowerCase() ==
                          account.accountName.toLowerCase())
                      .owed
                      .balance = 0;

                  AccountData.accountDataList
                      .firstWhere((e) =>
                          e.name.toLowerCase() ==
                          accTemp.owed.accountName.toLowerCase())
                      .owed
                      .balance = 0;

                  AccountData.accountDataList
                      .firstWhere((e) =>
                          e.name.toLowerCase() ==
                          account.accountName.toLowerCase())
                      .owed
                      .fromTo = "";

                  AccountData.accountDataList
                      .firstWhere((e) =>
                          e.name.toLowerCase() ==
                          accTemp.owed.accountName.toLowerCase())
                      .owed
                      .fromTo = "";

//
                  AccountData.accountDataList
                      .firstWhere((e) =>
                          e.name.toLowerCase() ==
                          account.accountName.toLowerCase())
                      .balance += tempOwed;

                  AccountData.accountDataList
                      .firstWhere((e) =>
                          e.name.toLowerCase() ==
                          accTemp.owed.accountName.toLowerCase())
                      .balance += owedVal;

                  msg1 =
                      " Transferred \$$owedVal to ${accTemp.owed.accountName}";
                  msg2 =
                      " Your balance is \$${AccountData.accountDataList.firstWhere((e) => e.name.toLowerCase() == account.accountName.toLowerCase()).balance}";
                  msg3 =
                      " Owed \$${AccountData.accountDataList.firstWhere((e) => e.name.toLowerCase() == account.accountName.toLowerCase()).owed.balance} ${AccountData.accountDataList.firstWhere((e) => e.name.toLowerCase() == account.accountName.toLowerCase()).owed.fromTo} ${AccountData.accountDataList.firstWhere((e) => e.name.toLowerCase() == account.accountName.toLowerCase()).owed.accountName}";
                  msgSum = "$msg1\n$msg2\n $msg3\n";
                } else {
                  var accTemp = AccountData.accountDataList.firstWhere((e) =>
                      e.name.toLowerCase() ==
                      account.accountName.toLowerCase());

                  AccountData.accountDataList
                      .firstWhere((e) =>
                          e.name.toLowerCase() ==
                          account.accountName.toLowerCase())
                      .owed
                      .balance -= depVal;

                  AccountData.accountDataList
                      .firstWhere((e) =>
                          e.name.toLowerCase() ==
                          accTemp.owed.accountName.toLowerCase())
                      .owed
                      .balance -= depVal;
                  AccountData.accountDataList
                      .firstWhere((e) =>
                          e.name.toLowerCase() ==
                          accTemp.owed.accountName.toLowerCase())
                      .balance += depVal;

                  msg1 =
                      " Transferred \$$depVal to ${accTemp.owed.accountName}";
                  msg2 =
                      " Your balance is \$${AccountData.accountDataList.firstWhere((e) => e.name.toLowerCase() == account.accountName.toLowerCase()).balance}";
                  msg3 =
                      " Owed \$${AccountData.accountDataList.firstWhere((e) => e.name.toLowerCase() == account.accountName.toLowerCase()).owed.balance} ${AccountData.accountDataList.firstWhere((e) => e.name.toLowerCase() == account.accountName.toLowerCase()).owed.fromTo} ${AccountData.accountDataList.firstWhere((e) => e.name.toLowerCase() == account.accountName.toLowerCase()).owed.accountName}";
                  msgSum = "$msg1\n$msg2\n $msg3\n";
                }
              } else {
                var accTemp = AccountData.accountDataList.firstWhere((e) =>
                    e.name.toLowerCase() == account.accountName.toLowerCase());
                AccountData.accountDataList
                    .firstWhere((e) =>
                        e.name.toLowerCase() ==
                        account.accountName.toLowerCase())
                    .balance = depVal;

                msg1 = " Transferred \$$depVal to ${accTemp.owed.accountName}";
                msg2 =
                    " Your balance is \$${AccountData.accountDataList.firstWhere((e) => e.name.toLowerCase() == account.accountName.toLowerCase()).balance}";
                msg3 =
                    " Owed \$${AccountData.accountDataList.firstWhere((e) => e.name.toLowerCase() == account.accountName.toLowerCase()).owed.balance} ${AccountData.accountDataList.firstWhere((e) => e.name.toLowerCase() == account.accountName.toLowerCase()).owed.fromTo} ${AccountData.accountDataList.firstWhere((e) => e.name.toLowerCase() == account.accountName.toLowerCase()).owed.accountName}";
                msgSum = "$msg1\n$msg2\n $msg3\n";
              }
            }
            account.message = msgSum;
            emit(ActionCommandLoadedState(account: account));
          }
          break;

        case "logout":
          account.accountName = account.accountName;
          account.isLogin = false;
          account.message = "Goodbye, ${account.accountName}! \n\n";
          account.accountName = "";
          emit(ActionCommandLoadedState(account: account));
          break;
        case "balance":
          var msg1 = "";
          var msg2 = "";
          var sumMsg = "";
          if (!isLogin!) {
            account.message = "Please login first";
            emit(ActionCommandLoadedState(account: account));
            // ignore: dead_code
          } else {
            account.accountName = account.accountName;
            var acc = AccountData.accountDataList.firstWhere((e) =>
                e.name.toLowerCase() == account.accountName.toLowerCase());

            msg1 = "Hello,  Your balance is \$ ${acc.balance}\n";
            sumMsg = "$msg1 ";

            if (acc.owed.balance > 0) {
              msg2 =
                  " Owed \$${acc.owed.balance} ${acc.owed.fromTo} ${acc.owed.accountName}\n";
              sumMsg = "$msg1 \n$msg2\n";
            }
            account.message = sumMsg;
            emit(ActionCommandLoadedState(account: account));
          }

          break;
        default:
          account.message = "Wrong command!\n";
          emit(ActionCommandLoadedState(account: account));
          break;
      }
    }
  }
}

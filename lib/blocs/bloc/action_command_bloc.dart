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
          // ignore: dead_code
          if (isLogin!) {
            account.message = "You already logged in.";
            //accList.add(account);
            isLogin = true;
            account.isLogin = true;
            emit(ActionCommandLoadedState(account: account));
          } else {
            for (var i = 0; i < AccountData.accountDataList().length; i++) {
              if (account.param.toLowerCase() ==
                  AccountData.accountDataList()[i].name.toLowerCase()) {
                account.accountName = account.param;
                account.message =
                    "Hello, ${account.accountName}! \n Your balance is \$ ${account.balance}";
                account.isLogin = true;

                break;
              } else {
                account.message = "Your account is not registered!";
                isLogin = false;
              }
            }
            emit(ActionCommandLoadedState(account: account));
          }
          break;
        case "transfer":
          if (!isLogin!) {
            account.message = "Please login first";
            emit(ActionCommandLoadedState(account: account));
            // ignore: dead_code
          } else {
            account.accountName = account.accountName;

            if (account.value < account.balance) {
              account.balance = account.balance - double.parse(account.param);

              for (var i = 0; i < AccountData.accountDataList().length; i++) {
                if (account.accountName.toLowerCase() ==
                    AccountData.accountDataList()[i].name.toLowerCase()) {
                  AccountData.accountDataList()[i].balance = account.balance;
                  AccountData.accountDataList()[i].owed = account.owed;
                }
              }

              account.message = "Your balance is \$ ${account.balance} \n ";

              emit(ActionCommandLoadedState(account: account));
            } else {
              account.message = "Insufficient balance";
              emit(ActionCommandLoadedState(account: account));
            }
          }
          break;
        case "deposit":
          // ignore: dead_code
          if (!isLogin!) {
            account.message = "Please login first";
            emit(ActionCommandLoadedState(account: account));
            // ignore: dead_code
          } else {
            account.accountName = account.accountName;
            account.balance = account.balance + double.parse(account.param);
            account.message = "Your balance is \$ ${account.balance}";

            for (var i = 0; i < AccountData.accountDataList().length; i++) {
              if (account.accountName.toLowerCase() ==
                  AccountData.accountDataList()[i].name.toLowerCase()) {
                AccountData.accountDataList()[i].balance = account.balance;
                AccountData.accountDataList()[i].owed = account.owed;
              }
            }
            emit(ActionCommandLoadedState(account: account));
          }
          break;
        case "logout":
          account.isLogin = true;
          account.message = "Goodbye, ${account.accountName}!";
          emit(ActionCommandLoadedState(account: account));
          break;
        default:
          account.message = "Wrong command!";
          emit(ActionCommandLoadedState(account: account));
          break;
      }
    }
  }
}

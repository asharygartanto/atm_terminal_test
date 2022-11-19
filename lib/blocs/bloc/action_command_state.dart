// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'action_command_bloc.dart';

abstract class ActionCommandState {
  const ActionCommandState();

  @override
  Object get props => [];
}

class ActionCommandInitialState extends ActionCommandState {}

class ActionCommandLoadingState extends ActionCommandState {}

class ActionCommandLoadedState extends ActionCommandState {
  Account? account;

  ActionCommandLoadedState({this.account});

  @override
  Object get props => [account];
}

class ActionCommandUpdateState extends ActionCommandState {
  final Account account;

  ActionCommandUpdateState(this.account);

  @override
  Object get props => [account];
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'action_command_bloc.dart';

abstract class ActionCommandEvent extends Equatable {
  const ActionCommandEvent();

  @override
  List<Object> get props => [];
}

class LoadAction extends ActionCommandEvent {
  const LoadAction();
  @override
  List<Object> get props => [];
}

class UpdateAction extends ActionCommandEvent {
  final Account account;
  const UpdateAction({
    required this.account,
  });

  @override
  List<Object> get props => [account];
}

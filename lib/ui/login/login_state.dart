part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginSuccessful extends LoginState{

}

class ErrorOccurred extends LoginState{
  final String errorMessage;

  ErrorOccurred(this.errorMessage);
}

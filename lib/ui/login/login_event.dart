part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginWithUsernameAndPassword extends LoginEvent{
  final String userName;
  final String password;

  LoginWithUsernameAndPassword(this.userName, this.password);

}

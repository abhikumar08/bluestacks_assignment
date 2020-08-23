import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bluestacks_assignment/utils/shared_preferece_helper.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginWithUsernameAndPassword) {
      if (event.userName == '9898989898' && event.password == "password123") {
        await SharedPreferencesHelper().setIsLoggedIn(true);
        yield LoginSuccessful();
      } else if (event.userName == '9876543210' &&
          event.password == "password123") {
        await SharedPreferencesHelper().setIsLoggedIn(true);
        yield LoginSuccessful();
      } else {
        yield ErrorOccurred("Invalid credentials, Please try again");
      }
    }
  }
}

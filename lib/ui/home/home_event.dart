part of 'home_bloc.dart';

abstract class HomeEvent {}

class GetProfile extends HomeEvent {}

class GetTournaments extends HomeEvent {
  final String cursor;

  GetTournaments({this.cursor});
}

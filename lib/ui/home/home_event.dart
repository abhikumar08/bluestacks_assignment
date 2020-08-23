part of 'home_bloc.dart';

abstract class HomeEvent {}

@immutable
class GetProfile extends HomeEvent {}

class GetTournaments extends HomeEvent {
  final String cursor;

  GetTournaments({this.cursor});
}

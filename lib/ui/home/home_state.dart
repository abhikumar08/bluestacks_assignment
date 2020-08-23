part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class TournamentsFetchedState extends HomeState {
  final List<Tournament> tournaments;
  final bool hasReachedMax;
  final String cursor;

  TournamentsFetchedState( {this.tournaments, this.hasReachedMax,this.cursor,});

  @override
  String toString() =>
      'Weddings Loaded { users: ${tournaments.length}, hasReachedMax: $hasReachedMax }';

  TournamentsFetchedState copyWith(
      {List<Tournament> tournaments, bool hasReachedMax, String cursor}) {
    return TournamentsFetchedState(
        tournaments: tournaments ?? this.tournaments,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    cursor:cursor??this.cursor);
  }
}

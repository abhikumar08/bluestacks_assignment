import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bluestacks_assignment/api/repository/tournaments_repository.dart';
import 'package:bluestacks_assignment/api/repository/user_repository.dart';
import 'package:bluestacks_assignment/model/tournaments.dart';
import 'package:bluestacks_assignment/model/user.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final UserRepository _userRepository = UserRepository();
  final TournamentRepository _tournamentRepository = TournamentRepository();

  HomeBloc() : super(HomeInitial());

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is GetProfile) {
      var data = await _userRepository.getProfile();
      User user = User.fromJson(data);
      if (user != null) {
        yield ProfileFetchedState(user);
      }
    }
    if (event is GetTournaments) {
      var data =
          await _tournamentRepository.getTournaments(cursor: event.cursor);
      PaginatedTournament paginatedTournament =
          PaginatedTournament.fromJson(data);
      if (paginatedTournament != null) {
        yield TournamentsFetchedState(
            tournaments: paginatedTournament.tournaments,
            hasReachedMax: paginatedTournament.tournaments.length < 10,
            cursor: paginatedTournament.cursor);
      }
    }
  }

  @override
  Stream<Transition<HomeEvent, HomeState>> transformEvents(
      Stream<HomeEvent> events, transitionFn) {

    return super.transformEvents(
      events.debounceTime(
        Duration(milliseconds: 500),
      ),
      transitionFn,
    );
  }
}

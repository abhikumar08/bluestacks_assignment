import 'package:bluestacks_assignment/api/api_client.dart';

class TournamentRepository {
  ApiClient _apiClient = ApiClient();

  static final TournamentRepository _singleton =
      TournamentRepository._internal();

  factory TournamentRepository() {
    return _singleton;
  }

  TournamentRepository._internal();

  Future<dynamic> getTournaments(
      {int limit = 10, String status = 'all', String cursor}) {
    var queries = {
      'limit': limit,
      'status': status,
    };
    if (cursor != null) {
      queries.addAll({'cursor': cursor});
    }
    return _apiClient.get(ApiClient.TOURNAMENTS, queryParams: queries);
  }
}

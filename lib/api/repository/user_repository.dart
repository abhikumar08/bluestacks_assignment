import 'package:bluestacks_assignment/api/api_client.dart';

class UserRepository {
  ApiClient _apiClient = ApiClient();

  static final UserRepository _singleton = UserRepository._internal();

  factory UserRepository() {
    return _singleton;
  }

  UserRepository._internal();

  Future<dynamic> login(String username, String password) {
    var body = Map<String, dynamic>();
    body['username'] = username;
    body['password'] = password;
    return _apiClient.post(ApiClient.LOGIN, body);
  }
  
  Future<dynamic> getProfile(){
    return _apiClient.get(null, completeUrl: ApiClient.PROFILE_URL);
  }
}

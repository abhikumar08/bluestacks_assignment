class AuthResponse {
  String accessToken;
  String refreshToken;
  User user;

  AuthResponse({this.accessToken, this.refreshToken, this.user});

  AuthResponse.fromJson(Map<String, dynamic> json) {
    accessToken = json['token'];
    refreshToken = json['refreshToken'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.accessToken;
    data['refreshToken'] = this.refreshToken;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class User {
  String id;
  String fullName;
  String profilePicture;
  int rating;
  String userName;
  TournamentsStats tournamentsStats;

  User(
      {this.id,
      this.fullName,
      this.profilePicture,
      this.rating,
      this.userName,
      this.tournamentsStats});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    profilePicture = json['profile_picture'];
    rating = json['rating'];
    userName = json['user_name'];
    tournamentsStats = json['tournaments_stats'] != null
        ? new TournamentsStats.fromJson(json['tournaments_stats'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['full_name'] = this.fullName;
    data['profile_picture'] = this.profilePicture;
    data['rating'] = this.rating;
    data['user_name'] = this.userName;
    if (this.tournamentsStats != null) {
      data['tournaments_stats'] = this.tournamentsStats.toJson();
    }
    return data;
  }
}

class TournamentsStats {
  int played;
  int won;

  TournamentsStats({this.played, this.won});

  TournamentsStats.fromJson(Map<String, dynamic> json) {
    played = json['played'];
    won = json['won'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['played'] = this.played;
    data['won'] = this.won;
    return data;
  }

  int getWinningPercentage() {
    return ((won / played) * 100).toInt();
  }
}

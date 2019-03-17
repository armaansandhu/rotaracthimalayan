class User {
  String id;
  String name;
  String college;
  String designation;
  String team;
  String dp;
  List<dynamic> subscription;
  List<dynamic> myMeetings;

  User(
      {this.id,
      this.name,
      this.college,
      this.designation,
      this.team,
      this.dp,
      this.subscription,
      this.myMeetings});

  static User fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        name: json['name'],
        college: json['college'],
        designation: json['designation'],
        team: json['team'],
        dp: json['dp'],
        subscription: json['subscription'],
        myMeetings: json['meetings']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'college': college,
        'designation': designation,
        'team': team,
        'dp': dp,
        'subscription': subscription
      };
}

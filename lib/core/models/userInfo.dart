class BasicUser {
  String id;
  String name;
  String college;
  String designation;
  String team;
  String dp;

  BasicUser(
      {this.id, this.name, this.college, this.designation, this.team, this.dp});

  static BasicUser fromJson(Map<String, dynamic> json) {
    return BasicUser(
      id: json['id'],
      name: json['name'],
      college: json['college'],
      designation: json['designation'],
      team: json['team'],
      dp: json['dp'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'college': college,
        'designation': designation,
        'team': team,
        'dp': dp,
      };
}

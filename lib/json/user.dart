class User{
  String name;
  String college;
  String designation;
  String team;
  String dp;
  List<dynamic> projects;
  List<dynamic> committees;
  List<dynamic> events;

  User({
    this.name,this.college,this.designation,this.team,this.dp,this.projects,this.committees,this.events,
  });

  static User fromJson(Map<String,dynamic> json){
    return User(
      name: json['name'],
      college: json['college'],
      designation: json['designation'],
      team: json['team'],
      dp: json['dp'],
      projects: json['projects'],
      committees: json['committees'],
      events: json['events'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'college': college,
    'designation': designation,
    'team': team,
    'dp': dp,
    'projects': projects,
    'committees': committees,
    'events': events,
  };
}

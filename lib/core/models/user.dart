class User{
  String id;
  String name;
  String college;
  String designation;
  String team;
  String dp;
  List<dynamic> projects;
  List<dynamic> committees;
  List<dynamic> events;
  List<dynamic> myMeetings;

  User({
    this.id,this.name,this.college,this.designation,this.team,this.dp,this.projects,this.committees,this.events,this.myMeetings
  });


   static User fromJson(Map<String,dynamic> json){
    return User(
      id: json['userInfo']['id'],
      name: json['userInfo']['name'],
      college: json['userInfo']['college'],
      designation: json['userInfo']['designation'],
      team: json['userInfo']['team'],
      dp: json['userInfo']['dp'],
      projects: ToList(json['projects']).list,
      committees: ToList(json['committees']).list,
      events: ToList(json['events']).list,
      myMeetings: json['userInfo']['meetings']
    );
  }

  Map<String, dynamic> toJson() => {
     'id': id,
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

class ToList{
  List<String> tmp = List();

  ToList(docs){
      docs.forEach((item){
        if(item['checked'] == true)
          tmp.add(item['name']);
      });
    }

    List get list => tmp;
}

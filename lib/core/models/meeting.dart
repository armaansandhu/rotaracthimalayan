import 'package:intl/intl.dart';

class Meeting {
  String title;
  String agenda;
  String category;
  String period;
  String location;
  String time;
  String date;
  String type;
  List<dynamic> going;
  String reference;

  Meeting(
      {this.title,
      this.agenda,
      this.category,
      this.period,
      this.location,
      this.time,
      this.date,
      this.type,
      this.going,
      this.reference});

  static Meeting fromJson(Map<String, dynamic> json) {
    return Meeting(
        title: json['title'],
        agenda: json['agenda'],
        category: json['category'],
        period: json['period'],
        location: json['location'],
        time: ToString(json['dateTime']).time,
        date: ToString(json['dateTime']).date,
        going: json['going'],
        reference: json['reference']);
  }
}

//Convert Date to formatted date & time
class ToString {
  final dateFormatter = new DateFormat('EEEE, d MMMM');
  final timeFormatter = new DateFormat('jm');
  String dateString;
  String timeString;

  ToString(input) {
    dateString = dateFormatter.format(input);
    timeString = timeFormatter.format(input);
  }

  String get date => dateString;

  String get time => timeString;
}

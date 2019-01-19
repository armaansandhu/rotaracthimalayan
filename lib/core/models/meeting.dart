import 'package:cloud_firestore/cloud_firestore.dart';
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

  DocumentReference reference;


  Meeting({this.title, this.agenda, this.category, this.period, this.location,
    this.time, this.date, this.type, this.going, this.reference});

  static Meeting fromJson(Map<String, dynamic> json) {
    return Meeting(
        title: json['title'],
        agenda: json['agenda'],
        category: json['category'],
        period: json['date'],
        location: json['location'],
        time: ToString(json['time']).time,
        date: ToString(json['time']).date,
        going: json['going'],
        reference: json['reference']
    );
  }
}

class ToString{
  final dateFormatter = new DateFormat('EEEE, d MMMM');
  final timeFormatter = new DateFormat('jm');
  String dateString;
  String timeString;
  ToString(input){
    dateString = dateFormatter.format(input);
    timeString = timeFormatter.format(input);
  }
  
  String get date => dateString;
  String get time => timeString;
}
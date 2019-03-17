import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:rotaract_app/core/constants/constants.dart';

class ScheduleMeeting extends StatefulWidget {
  ScheduleMeeting(this.id);

  final id;

  @override
  _ScheduleMeetingState createState() => _ScheduleMeetingState();
}

class _ScheduleMeetingState extends State<ScheduleMeeting> {
  final dateFormat = DateFormat("d MMMM yy'");
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  DateTime date;
  String title;
  String agenda;
  String location;
  String type;
  DocumentReference reference;
  List<String> categories;
  bool isLoading = true;
  String category = null;
  final formKey = GlobalKey<FormState>();

  validate(String value) {
    return value.isEmpty ? 'TextField can\'t be empty' : null;
  }

  bool validateAndSave(inputName) {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldState,
        backgroundColor: themeColor,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: themeColor,
              title: Text('Schedule Meeting'),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              Padding(
                padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                child: Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 32.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        elevation: 0.0,
                        shadowColor: Colors.black87,
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          child: formInputs(),
                        ),
                      ),
                    )),
              )
            ]))
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> loadingList = [
    DropdownMenuItem(
      child: Text('Category'),
    ),
    DropdownMenuItem(
      child: CircularProgressIndicator(),
    )
  ];

  uploadMeeting() async {
    Navigator.of(context).pop('success');
    formKey.currentState.save();
    reference = Firestore.instance
        .document('meetings/${dateFormat.format(date)}');
    List<String> stringList= [];
    final meetingMap = {
      'category': category,
      'period': 'upcoming',
      'location': location,
      'reference': 'meetings/${dateFormat.format(date)}',
      'dateTime': date,
      'type': 'General',
      'title': title,
      'agenda': agenda,
      'appointedById' : widget.id,
      'going' : stringList
    };
    await reference.setData(meetingMap);
  }

  getCategories() async {
    await Firestore.instance
        .document('admin/${widget.id}')
        .get()
        .then((snapshot) {
      categories = new List.from(snapshot.data['programs']);
      setState(() {
        isLoading = false;
      });
    });
  }

  formInputs() {
    return Column(
      children: <Widget>[
        TextFormField(
            onSaved: (ti) {
              setState((){
                title = ti;
              });
            },
            decoration: inputDecoration(hint: 'Title', icon: Icons.title)),
        TextFormField(
            onSaved: (t) {
              setState(() {
                agenda = t;
              });
            },
            keyboardType: TextInputType.multiline,
            maxLines: 10,
            maxLengthEnforced: true,
            decoration:
                inputDecoration(hint: 'Agenda', icon: Icons.view_agenda)),
        TextFormField(
            onSaved: (t) {
              setState(() {
                location = t;
              });
            },
            decoration:
                inputDecoration(hint: 'Place', icon: Icons.location_on)),
        FormField(
          builder: (FormFieldState state) {
            return InputDecorator(
              decoration: InputDecoration(
                icon: Icon(Icons.category),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 14.0),
                child: new DropdownButtonHideUnderline(
                  child: DropdownButton(
                      hint: Text('Category'),
                      value: category,
                      items: isLoading == true
                          ? loadingList
                          : categories.map((String value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              );
                            }).toList(),
                      onChanged: (String newValue) {
                        setState(() {
                          category = newValue;
                          state.didChange(newValue);
                        });
                      }),
                ),
              ),
            );
          },
        ),
        DateTimePickerFormField(
          decoration:
              inputDecoration(hint: 'Time and Date', icon: Icons.date_range),
          onChanged: (dt) => setState(() {
                date = dt;
                print(date);
              }),
          format: dateFormat,
          inputType: InputType.both,
        ),
        SizedBox(
          height: 16.0,
        ),
        Container(
          width: MediaQuery.of(context).size.width * .8,
          child: Material(
              child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
              color: Colors.blue,
              shape: BoxShape.rectangle,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(100.0),
              //Something large to ensure a circle
              onTap: () async {
                final snackBar = SnackBar(
                  content: Text('Meeting Scheduled!'),
                );
                String returnVal = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'Please Confirm the Meeting',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        actions: <Widget>[
                          FlatButton(
                              onPressed: uploadMeeting, child: Text('Confirm')),
                          FlatButton(
                              onPressed: () =>
                                  Navigator.of(context).pop('dismiss'),
                              child: Text('Dismiss')),
                        ],
                      );
                    });
                if (returnVal == 'success')
                  _scaffoldState.currentState.showSnackBar(snackBar);
              },
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Center(
                    child: Text(
                  'Schedule',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                )),
              ),
            ),
          )),
        ),
      ],
    );
  }
}

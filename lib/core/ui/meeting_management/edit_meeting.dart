import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:rotaract_app/core/constants/constants.dart';

class EditMeeting extends StatefulWidget {
  EditMeeting(this.meeting,this.id);
  final id;
  final DocumentSnapshot meeting;

  @override
  _EditMeetingState createState() => _EditMeetingState();
}

class _EditMeetingState extends State<EditMeeting> {
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
  DocumentSnapshot meeting;

  validate(String value) {
    return value.isEmpty ? 'TextField can\'t be empty' : null;
  }

  updateMeeting() async {
    formKey.currentState.save();
    final meetingMap = {
      'category': category == null ? meeting.data['category'] : category,
      'date': 'upcoming',
      'location': location,
      'reference': meeting.reference,
      'time': date == null ? meeting.data['dateTime'] : date,
      'type': 'meeting',
      'title': title,
      'agenda': agenda,
    };
    await meeting.reference.updateData(meetingMap);
    Navigator.pop(context);
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
    meeting = widget.meeting;
    title = meeting.data['title'];
    agenda = meeting.data['agenda'];
    date = meeting.data['dateTime'];
    location = meeting.data['location'];
    super.initState();
  }

  deleteMeeting() async {
    final snackBar = SnackBar(
      content: Text('Meeting Deleted!'),
    );
    String returnVal = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Please Confirm the action',
              style: TextStyle(fontSize: 16.0),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () =>
                      Navigator.of(context).pop('dismiss'),
                  child: Text('Dismiss')),
              FlatButton(
                  onPressed: ()async{
                    Navigator.of(context).pop('success');
                    await meeting.reference.delete();
                  }, child: Text('Confirm')),
            ],
          );
        });
    if (returnVal == 'success'){
      _scaffoldState.currentState.showSnackBar(snackBar);
      Navigator.pop(context);
    }
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
              title: Text('Update Meeting'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: deleteMeeting,)
              ],
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
      child: Text(''),
    ),
    DropdownMenuItem(
      child: CircularProgressIndicator(),
    )
  ];



  formInputs() {
    return Column(
      children: <Widget>[
        TextFormField(
            onSaved: (ti) {
              setState((){
                title = ti;
              });
            },
            initialValue: title,
            decoration: inputDecoration(hint: 'Title', icon: Icons.title)),
        TextFormField(
            onSaved: (t) {
              setState(() {
                agenda = t;
              });
            },
            initialValue: agenda,
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
            initialValue: location,
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
                      hint: Text(meeting.data['category'],style: TextStyle(color: Colors.black),),
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
          initialValue: date,
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
                  color: Colors.blueAccent,
                  shape: BoxShape.rectangle,
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(100.0),
                  //Something large to ensure a circle
                  onTap: updateMeeting,
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                        child: Text(
                          'Update',
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
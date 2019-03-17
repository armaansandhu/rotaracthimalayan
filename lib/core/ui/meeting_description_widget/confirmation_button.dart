import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:rotaract_app/core/models/meeting.dart';

class ConfirmationButton extends StatefulWidget {
  ConfirmationButton(this.meeting, this.id);
  final Meeting meeting;
  final id;
  @override
  _ConfirmationButtonState createState() => _ConfirmationButtonState();
}

enum ButtonView{
  undecided,
  going,
}

class _ConfirmationButtonState extends State<ConfirmationButton> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<Color> colorAnimation;
  Animation<double> position;
  Animation<double> popAnimation;
  Color buttonColor;
  Text confirmationText;
  ButtonView buttonView;
  var id;
  bool isLoading;
  String dp;
  List<dynamic> myMeetingList;
  DocumentReference reference;

  @override
  void initState() {
    super.initState();
    reference = Firestore.instance.document(widget.meeting.reference);
    isLoading = true;
    id = widget.id;
    _controller = AnimationController(vsync: this,duration: Duration(milliseconds: 100));
    initButtonView();
  }
  initButtonView() async{
    print(id);
    await Firestore.instance.document('users/$id').get().then((snapshot){
      dp = snapshot.data['dp'];
      myMeetingList = List.from(widget.meeting.going);
    });
    await reference.collection('going').document(id).get()
        .then((docSnapshot){
      if(docSnapshot.exists) {
        buttonView = ButtonView.going;
        buttonColor = Colors.green;
        confirmationText = Text("Hurray! You're coming.", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0,color: Colors.green),);
      } else {
        buttonView = ButtonView.undecided;
        buttonColor = Colors.white;
        confirmationText = Text("Are you going?", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0,color: Colors.grey),);
      }
    });
    initializeAnimationState();
  }

  initializeAnimationState() async{
    var curve = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    colorAnimation = ColorTween(begin: Colors.grey,end: Colors.green).animate(curve)
      ..addListener((){setState(() {});});
    position = Tween(begin: 0.0, end: 20.0).animate(curve);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(isLoading == false)
      return Container(
        height: 120.0,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                height: 80.0,
                width: MediaQuery.of(context).size.width*.6,
                child: Center(child: confirmationText),
              ),
              GestureDetector(
                  onTap: () async {
                    if(buttonView == ButtonView.going){
                      setState(() {
                        buttonColor = Colors.white;
                        confirmationText = Text("Are you going?", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0,color: Colors.grey),);
                      });
                      await _controller.forward();
                      await _controller.reverse();
                      await notGoing();
                    }
                    else if(buttonView == ButtonView.undecided){
                      setState(() {
                        buttonColor = Colors.green;
                        confirmationText = Text("Hurray! You're coming.", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0,color: Colors.green),);
                      });
                      await _controller.forward();
                      await _controller.reverse();
                      await going();

                    }
                    buttonView = buttonView == ButtonView.going ? ButtonView.undecided : ButtonView.going;
                  },
                  child: CircleAvatar(radius: 30.0 + position.value,backgroundColor: buttonColor,
                      child: Icon(Icons.thumb_up,size: 30.0,)
                  ))]),
      );
    else
      return _buttonPlaceHolder();
  }

  Widget _buttonPlaceHolder(){
    return Container(height: 120.0,
      child: Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      height: 20.0,
                      width: MediaQuery.of(context).size.width*.7,
                      decoration: new BoxDecoration(
                          color: Colors.green,
                          borderRadius: new BorderRadius.all(Radius.circular(30.0))),
                    ),
                    Container(
                      height: 20.0,
                      width: MediaQuery.of(context).size.width*.7,
                      decoration: new BoxDecoration(
                          color: Colors.green,
                          borderRadius: new BorderRadius.all(Radius.circular(30.0))),
                    ),
                  ],
                ),
                CircleAvatar(radius: 40.0,backgroundColor: Colors.white,)])
      ),);
  }

  going() async{
    await reference.collection('going').document('$id').setData({
      'id' : id,
      'dp' : dp,
    });
    myMeetingList.removeWhere((item) => item == widget.meeting.reference);
    myMeetingList.add(widget.id);
    await reference.updateData({
      'going' : myMeetingList
    });
  }

  notGoing() async{
    myMeetingList.removeWhere((item) => item == widget.id);
    await reference.collection('going').document(id).delete();
    await reference.updateData({
      'going' : myMeetingList
    });
  }
}
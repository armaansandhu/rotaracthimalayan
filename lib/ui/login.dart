import 'package:flutter/material.dart';
import 'package:rotaract_app/utils/authprovider.dart';


class EmailFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Email can\'t be empty' : null;
  }
}

class PasswordFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Password can\'t be empty' : null;
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({this.onSignedIn});
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  bool errorVisibility = false;
  String _email;
  String _password;

  Size screenSize(BuildContext context) => MediaQuery.of(context).size;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        var auth = AuthProvider.of(context).auth;
        String userId =
        await auth.signInWithEmailAndPassword(_email, _password);
        widget.onSignedIn();
        print(userId);
      } catch (e) {
        setState(() {
          errorVisibility = true;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rotaract Himalyan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.red),
      home: Scaffold(
          body: Container(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: ListView(
                  children: buildInputs() + buildSubmitButtons(),
                ),
              ))),
    );

  }

  List<Widget> buildInputs() {
    return [
      Container(
          //
          height: 250.0,
        padding: EdgeInsets.fromLTRB(0.0,50.0,0.0,0.0),
          child: Image.asset('images/rh.png'),

      ),


        Container(
          //height: 100.0,
          padding: EdgeInsets.fromLTRB(10.0,150.0,10.0,10.0),
          child:TextFormField(
        key: Key('email'),
        decoration: InputDecoration(

          hintText: 'Email',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
        validator: EmailFieldValidator.validate,
        onSaved: (value) => _email = value,
      ),
        ),
      Container(
        //height: 100.0,
        padding: EdgeInsets.fromLTRB(10.0,20.0,10.0,10.0),
       child:TextFormField(
        key: Key('password'),
        decoration: InputDecoration(
          hintText: 'Password',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
        obscureText: true,
        validator: PasswordFieldValidator.validate,
        onSaved: (value) => _password = value,
      ),
      ),

      Visibility(child: Text('Username or Password do not match', style: TextStyle(color: Colors.red)), maintainState: true,maintainAnimation: true, visible: errorVisibility)
    ];
  }

  List<Widget> buildSubmitButtons() {
      return [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Material(
          borderRadius: BorderRadius.circular(30.0),
          shadowColor: Colors.redAccent,
          elevation: 5.0,
          child: MaterialButton(
            minWidth: 200.0,
            height: 42.0,
            onPressed: validateAndSubmit,
            color: const Color(0xff9d030b),
            child: Text('Log In', style: TextStyle(color: Colors.white)),
          ),
        ),
      ),

      ];
  }
}

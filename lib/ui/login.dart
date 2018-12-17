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
          height: 100.0,
          child: Image.network('https://pbs.twimg.com/profile_images/768405797998997504/C6hLIZSJ_400x400.jpg',)),
      TextFormField(
        key: Key('email'),
        decoration: InputDecoration(labelText: 'Email'),
        validator: EmailFieldValidator.validate,
        onSaved: (value) => _email = value,
      ),
      TextFormField(
        key: Key('password'),
        decoration: InputDecoration(labelText: 'Password'),
        obscureText: true,
        validator: PasswordFieldValidator.validate,
        onSaved: (value) => _password = value,
      ),
      Visibility(child: Text('Username or Password do not match', style: TextStyle(color: Colors.red)), maintainState: true,maintainAnimation: true, visible: errorVisibility)
    ];
  }

  List<Widget> buildSubmitButtons() {
      return [
        RaisedButton(
          key: Key('signIn'),
          child: Text('Login', style: TextStyle(fontSize: 20.0)),
          onPressed: validateAndSubmit,
        ),
      ];
  }
}
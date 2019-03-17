import 'package:flutter/material.dart';
import 'package:rotaract_app/core/constants/constants.dart';
import 'package:rotaract_app/core/utils/authprovider.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  Widget loginState = Text('Log In', style: TextStyle(color: Colors.white));
  FocusNode passwordFocus;

  Size screenSize(BuildContext context) => MediaQuery.of(context).size;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    setState(() {
      loginState = Text('Log In', style: TextStyle(color: Colors.white));
    });
    return false;
  }

  void validateAndSubmit() async {
    setState(() {
      loginState = SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white)));
    });
    await Future.delayed(Duration(seconds: 1)).then((_) async {
      if (validateAndSave()) {
        try {
          var auth = AuthProvider.of(context).auth;
          String userId =
              await auth.signInWithEmailAndPassword(_email, _password);
          widget.onSignedIn();
          print(userId);
        } catch (e) {
          setState(() {
            loginState = Text('Log In', style: TextStyle(color: Colors.white));
            errorVisibility = true;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rotaract Himalyan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.red),
      home: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: ListView(
                  children:
                      buildInputs() + buildSubmitButtons() + forgotPassword(),
                ),
              ))),
    );
  }

  List<Widget> buildInputs() {
    return [
      Container(
        height: 250.0,
        padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
        child: Image.asset('images/rh.png'),
      ),
      Container(
        padding: EdgeInsets.fromLTRB(10.0, 80.0, 10.0, 10.0),
        child: TextFormField(
          key: Key('email'),
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Email',
            contentPadding:
                EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
          validator: EmailFieldValidator.validate,
          onSaved: (value) => _email = value,
        ),
      ),
      Container(
        padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
        child: TextFormField(
          key: Key('password'),
          decoration: InputDecoration(
            hintText: 'Password',
            contentPadding:
                EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
          obscureText: true,
          validator: PasswordFieldValidator.validate,
          onSaved: (value) => _password = value,
        ),
      ),
      Visibility(
          child: Text('Username or Password do not match',
              style: TextStyle(color: Colors.red)),
          maintainState: true,
          maintainAnimation: true,
          visible: errorVisibility)
    ];
  }

  List<Widget> buildSubmitButtons() {
    return [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Container(
          width: MediaQuery.of(context).size.width * .8,
          height: 60,
          child: Material(
              child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
              color: themeColor,
              shape: BoxShape.rectangle,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(100.0),
              splashColor: Colors.red,
              onTap: validateAndSubmit,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Center(child: loginState),
              ),
            ),
          )),
        ),
      ),
    ];
  }

  List<Widget> forgotPassword() {
    return [
      Center(
          child: GestureDetector(
        child: Text(
          'Forgot Password?',
          style: TextStyle(
              decoration: TextDecoration.underline, color: themeColor),
        ),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => ForgotPassword())),
      ))
    ];
  }
}

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  var requestText = 'Request Password';
  var text = '';
  var visibility = true;
  var email;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Forgot Password'),
          backgroundColor: themeColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: forgotPassword(),
          ),
        ),
      ),
    );
  }

  List<Widget> forgotPassword() {
    return [
      SizedBox(
        height: 200.0,
      ),
      TextField(
        autofocus: true,
        decoration: InputDecoration(
          labelText: 'Email',
          prefixIcon: Icon(
            Icons.email,
            color: themeColor,
          ),
          //border: OutlineInputBorder(),
        ),
        controller: controller,
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Container(
          width: MediaQuery.of(context).size.width * .8,
          height: 60,
          child: Material(
              child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
              color: themeColor,
              shape: BoxShape.rectangle,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(100.0),
              splashColor: Colors.red,
              onTap: () async {
                try {
                  setState(() {
                    requestText = 'Requesting...';
                  });
                  await FirebaseAuth.instance
                      .sendPasswordResetEmail(email: controller.value.text);
                  setState(() {
                    visibility = true;
                    text = 'Password Reset mail sent to your email address';
                    requestText = 'Successfully Requested!';
                  });
                } catch (e) {
                  setState(() {
                    visibility = true;
                    text = 'User does not exist!';
                  });
                }
              },
              child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(
                      child: Text(
                    requestText,
                    style: TextStyle(color: Colors.white),
                  ))),
            ),
          )),
        ),
      ),
      Visibility(
        child: Text(text),
        visible: visibility,
      )
    ];
  }
}

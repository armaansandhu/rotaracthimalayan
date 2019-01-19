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
      loginState = CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white));
    });
    await Future.delayed(Duration(seconds: 1)).then((_) async{
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
  void initState() {
    passwordFocus = FocusNode();
    super.initState();
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
                  children: buildInputs() + buildSubmitButtons() + forgotPassword(),
                ),
              ))),
    );

  }

  List<Widget> buildInputs() {


    return [
      Container(
        height: 250.0,
        padding: EdgeInsets.fromLTRB(0.0,50.0,0.0,0.0),
        child: Image.network('https://pbs.twimg.com/profile_images/768405797998997504/C6hLIZSJ_400x400.jpg'),
      ),
      Container(
        padding: EdgeInsets.fromLTRB(10.0,80.0,10.0,10.0),
        child:TextFormField(
          key: Key('email'),
          textInputAction: TextInputAction.next,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Email',
            contentPadding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 16.0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
          validator: EmailFieldValidator.validate,
          onSaved: (value) => _email = value,
          onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(passwordFocus),
        ),
      ),
      Container(
        //height: 100.0,
        padding: EdgeInsets.fromLTRB(10.0,20.0,10.0,10.0),
        child:TextFormField(
          key: Key('password'),
          focusNode: passwordFocus,
          decoration: InputDecoration(
            hintText: 'Password',
            contentPadding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 16.0),
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
        child: MaterialButton(
          minWidth: 200.0,
          height: 56.0,
          onPressed: validateAndSubmit,
          color: const Color(0xff9d030b),
          child: loginState,
        ),
      ),

    ];
  }

  List<Widget> forgotPassword() {
    return [
      Center(
          child: GestureDetector(
            child: Text('Forgot Password?'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ForgotPassword())),
          )
      )
    ];
  }
}

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  var text = '';
  var visibility = true;
  var email;
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
      SizedBox(height: 200.0,),
      TextField(
        autofocus: true,
        decoration: InputDecoration(
          labelText: 'Email',
          prefixIcon: Icon(Icons.email,color: themeColor,),
          //border: OutlineInputBorder(),
        ),
        controller: controller,
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: MaterialButton(
          minWidth: 200.0,
          height: 56.0,
          onPressed: ()async{
            try{
              await FirebaseAuth.instance.sendPasswordResetEmail(email: controller.value.text);
              setState(() {
                visibility = true;
                text = 'Password Reset mail sent to your email address';
              });
            }catch(e){
              setState(() {
                visibility = true;
                text = 'User does not exist!';
              });
            }
          },
          color: const Color(0xff9d030b),
          child: Text('Request Password'),
        ),
      ),
      Visibility(child: Text(text),visible: visibility,)
    ];
  }
}


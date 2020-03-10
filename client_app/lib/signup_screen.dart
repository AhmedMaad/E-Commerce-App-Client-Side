import 'package:client_app/product_main_screen.dart';
import 'package:client_app/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  User u = new User();
  final _signupKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> signup() async {
    final formState = _signupKey.currentState;
    if (formState.validate()) {
      setState(() {
        isLoading = true;
      });
      formState.save();
      print(u.getEmail());
      print(u.getPassword());
      print(u.getConfirmPassword());
      try {
        FirebaseUser user = (await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                    email: u.getEmail(), password: u.getPassword()))
            .user;

        User.userID = user.uid;
        setState(() {
          isLoading = false;
        });
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProductMainScreen()));
      } catch (e) {
        print(e.message);
      }
    } else {
      print("Form is not valid");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Signup"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(16),
          child: Form(
            key: _signupKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(labelText: "Enter Email"),
                  validator: (value) =>
                      value.isEmpty ? "Email field is required" : null,
                  onSaved: (value) => u.setEmail(value),
                ),
                TextFormField(
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(labelText: "Enter your password"),
                  obscureText: true,
                  validator: (value) =>
                      value.isEmpty ? "Password field is required" : null,
                  onSaved: (value) => u.setPassword(value),
                ),
                TextFormField(
                  style: TextStyle(fontSize: 20),
                  decoration:
                      InputDecoration(labelText: "Confirm your password"),
                  obscureText: true,
                  validator: (value) => value.isEmpty
                      ? "Confirm password field is required"
                      : null,
                  onSaved: (value) => u.setConfirmPassword(value),
                ),
                Container(
                  margin: EdgeInsets.all(16),
                  child: RaisedButton(
                    onPressed: signup,
                    child: Text("Signup"),
                  ),
                ),
                Visibility(
                  visible: isLoading,
                  child: LinearProgressIndicator(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

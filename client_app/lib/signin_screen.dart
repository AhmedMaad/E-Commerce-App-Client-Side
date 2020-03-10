import 'package:client_app/product_main_screen.dart';
import 'package:client_app/user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignInScreenState();
  }
}

class SignInScreenState extends State<SignInScreen> {
  final _signinKey = GlobalKey<FormState>();
  User u = User();
  bool isLoading = false;

  Future<void> signin() async {
    final formState = _signinKey.currentState;
    if (formState.validate()) {
      setState(() {
        isLoading = true;
      });
      formState.save(); //this method mn8eerha el data httl3 null :)
      print(u.getEmail());
      print(u.getPassword());
      try {
        FirebaseUser myUser = (await FirebaseAuth.instance
                .signInWithEmailAndPassword(
                    email: u.getEmail(), password: u.getPassword()))
            .user;

        User.userID = myUser.uid;
        setState(() {
          isLoading = false;
        });
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ProductMainScreen()));
        //Navigate to home
      } catch (e) {
        print("Error while signing in " + e.message);
      }
    } else
      print('form is not valid');
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 16, right: 16),
        child: Form(
          key: _signinKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(labelText: "Enter your E-mail"),
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
              Container(
                margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                child: RaisedButton(
                  onPressed: signin,
                  child: Text("LOGIN"),
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
    );
  }
}

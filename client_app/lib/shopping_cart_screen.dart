import 'package:client_app/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ShoppingCartScreen extends StatefulWidget {
  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {

  @override
  Widget build(BuildContext context) {
    print("Current logged in user: ${User.userID}");
    return Scaffold(
      appBar: AppBar(
        title: Text("Purchased Products"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection("customerCollection")
            .where("userId", isEqualTo: User.userID)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError)
            Toast.show("Check your Internet connection", context, duration: 2);
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Loading...');
            default:
              return ListView(
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 30.0,
                      backgroundImage: NetworkImage(document["image"]),
                    ),
                    title: Text(
                      document["title"],
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing:
                        Text("Quantity= " + document["quantity"].toString()),
                    contentPadding: EdgeInsets.all(8),
                  );
                }).toList(),
              );
          }
        },
      ),
    );
  }
}

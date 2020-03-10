import 'package:client_app/product_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ProductsScreen extends StatefulWidget {
  ProductsScreen({this.categoryNumber});
  int categoryNumber;


  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("products").where("category", isEqualTo: (widget.categoryNumber)).snapshots(),
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
                  subtitle: Text(
                    document["description"],
                    style: TextStyle(fontSize: 16),
                  ),
                  contentPadding: EdgeInsets.all(8),
                  //onLongPress: () => showDeleteDialog(document.documentID),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(
                            title: document["title"],
                            description: document["description"],
                            image: document["image"],
                            price: document["price"],
                            quantity: document["quantity"],
                            latitude: document["lat"],
                            longitude: document["lon"],
                            documentID: document.documentID,
                          ))),
                );
              }).toList(),
            );
        }
      },
    );
  }
}

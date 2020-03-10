import 'dart:async';

import 'package:client_app/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spinner_input/spinner_input.dart';
import 'package:toast/toast.dart';

class ProductDetailsScreen extends StatefulWidget {
  String title, description, image, documentID;
  int quantity;
  double latitude, longitude, price;


  ProductDetailsScreen(
      {this.title,
      this.description,
      this.image,
      this.price,
      this.quantity,
      this.latitude,
      this.longitude,
      this.documentID});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final Map<String, Marker> _markers = {};
  double spinnerCounter = 1;
  int boughtQuantity = 1;

  Future<void> _onMapCreated(GoogleMapController controller) async {
    setState(() {
      final marker = Marker(
        markerId: MarkerId("vendorPlaceId"),
        position: LatLng(widget.latitude, widget.longitude),
        infoWindow: InfoWindow(

          title: "You vendor is here",
        ),
      );
      _markers["vendor place"] = marker;
    });
  }

  void addItem() async {
    print("Current logged in user: ${User.userID}");
    await Firestore.instance
        .collection("customerCollection")
        .document()
        .setData({
      "title": widget.title,
      "quantity": boughtQuantity,
      "image": widget.image,
      "userId": User.userID,
    });
    Toast.show("Item Added Successfully", context, duration: 2);

    if (widget.quantity - boughtQuantity == 0) {
      deleteItem();
    } else {
      updateItem();
    }
    widget.quantity -= boughtQuantity;
  }

  void updateItem() {
    try {
      Firestore.instance
          .collection("products")
          .document(widget.documentID)
          .updateData({"quantity": (widget.quantity - boughtQuantity)});
    } catch (e) {
      print(e.toString());
    }
  }

  void deleteItem() {
    try {
      Firestore.instance
          .collection("products")
          .document(widget.documentID)
          .delete();
    } catch (e) {
      print(e.toString());
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true, //keep the AppBarVisible even when collapsed
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.title),
              background: Image.network(
                widget.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverFillRemaining(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Price:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          widget.price.toString(),
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Description:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(
                            widget.description,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SpinnerInput(
                  spinnerValue: spinnerCounter,
                  minValue: 1,
                  maxValue: widget.quantity.toDouble(),
                  disabledLongPress: true,
                  disabledPopup: true,
                  onChange: (value) {
                    setState(() {
                      spinnerCounter = value;
                      boughtQuantity = value.toInt();
                    });
                  },
                ),
                Container(
                  margin:
                      EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 32),
                  width: MediaQuery.of(context).size.width,
                  height: 160,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(widget.latitude, widget.longitude),
                      zoom: 14,
                    ),
                    markers: _markers.values.toSet(),
                  ),
                ),
                RaisedButton(
                  onPressed: addItem,
                  child: Text("ADD TO CART"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

import 'package:client_app/shopping_cart_screen.dart';
import 'package:flutter/material.dart';
import 'products_screen.dart';

class ProductMainScreen extends StatefulWidget {

  @override
  _ProductMainScreenState createState() => _ProductMainScreenState();
}

class _ProductMainScreenState extends State<ProductMainScreen> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Categories"),
          bottom: TabBar(tabs: [
            Tab(
              text: "Clothes",
            ),
            Tab(
              text: "Electronics",
            ),
            Tab(
              text: "Furniture",
            ),
          ]),
        ),
        body: TabBarView(children: <Widget>[
          ProductsScreen(categoryNumber: 0),
          ProductsScreen(categoryNumber: 1),
          ProductsScreen(categoryNumber: 2),
        ]),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.shopping_cart),
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => ShoppingCartScreen())),
        ),
      ),
    );
  }
}

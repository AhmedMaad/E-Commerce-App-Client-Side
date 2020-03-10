import 'package:flutter/material.dart';

import 'home_screen.dart';

void main() => runApp(MaterialApp(
    theme: ThemeData(appBarTheme: AppBarTheme(color: Colors.deepPurple)),
    debugShowCheckedModeBanner: false,
    home: HomeScreen()));

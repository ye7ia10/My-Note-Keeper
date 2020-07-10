
import 'package:flut/screens/HomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


void main (){
  runApp(myNote());
}
class myNote extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Note Keeper",
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: homeScreen(),
    );
  }

}




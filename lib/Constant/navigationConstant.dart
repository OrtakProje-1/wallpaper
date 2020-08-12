import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class Navigation{

 void navigation(BuildContext context,Widget newPage){
    Navigator.push(context,MaterialPageRoute(builder:(_)=>newPage));
  }
}
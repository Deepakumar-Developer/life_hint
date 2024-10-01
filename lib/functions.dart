import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes_hint/colors.dart';

bool lightMode = true;
bool optionSwitch = false;
bool showTermsAndPolices = false;
bool okTermsAndPolices = false;
bool showTextField = false;
bool showDelete = false;
bool showStack = false;
bool obscureText = true;
bool showLoader = false;
int age = 30;
String childUid = FirebaseAuth.instance.currentUser!.uid;

int id = 2;
String deleteTitle = 'error';
String? deleteId;
final FirebaseFirestore fireStore = FirebaseFirestore.instance;

class Note {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });
}

void customStatusBar() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: color_30.withOpacity(0.5),
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: color_30.withOpacity(0.5),
  ));
}

void showToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: color_60,
      textColor: colorOthers,
      fontSize: 16.0);
}

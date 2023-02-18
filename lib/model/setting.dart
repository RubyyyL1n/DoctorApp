import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sqq_flutter2/components/briefInfomation.dart';
import 'package:sqq_flutter2/constants.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: kBlackColor900,
          onPressed: () {
            Navigator.of(context).popAndPushNamed('/');
          },
        ),
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 24, color: kBlackColor900),
          ),
      ),
      body: GetUserInformation(),
    );
  }
}




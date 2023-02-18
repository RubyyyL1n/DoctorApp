import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sqq_flutter2/constants.dart';

class helpCenter extends StatefulWidget {
  const helpCenter({Key? key}) : super(key: key);

  @override
  State<helpCenter> createState() => _helpCenterState();
}

class _helpCenterState extends State<helpCenter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, color: kBlackColor900,)),
        backgroundColor: kGreenColor,
        shadowColor: Colors.transparent,
        title: Text('Help Center', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: kBlackColor900),),
      ),
      body: Help(),
    );
  }
}

Widget Help(){
  return Column(
    children: [
      Card(
        margin: EdgeInsets.fromLTRB(16, 40, 16, 16),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Icon(
                        Icons.call,
                        color: Colors.grey[800],
                        size: 24,
                      ),
                    ),
                    Text(
                      'Call Center',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Text(
                  'If you run into any problems that can''t be solved, please call 1234567. We are very glad to be of service to you.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[900],
                    letterSpacing: 1.2,
                  ),
              )
            ],
          ),
        ),

),
      Card(
        margin: EdgeInsets.fromLTRB(16, 40, 16, 16),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Icon(
                        Icons.ad_units,
                        color: Colors.grey[800],
                        size: 24,
                      ),
                    ),
                    Text(
                      'Technical Support',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Text(
                'If no corresponding result appears when you click a button or page, please exit the application in the background and log in again.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[900],
                  letterSpacing: 1.2,
                ),
              )
            ],
          ),
        ),

      ),
      Card(
        margin: EdgeInsets.fromLTRB(16, 40, 16, 16),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Icon(
                        Icons.cable,
                        color: Colors.grey[800],
                        size: 24,
                      ),
                    ),
                    Text(
                      'Consultant Support',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Text(
                'The software provides a dialogue function, you can leave your questions in the dialog box, relevant personnel will reply to you in time, as far as possible to solve your problems.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[900],
                  letterSpacing: 1.2,
                ),
              )
            ],
          ),
        ),

      ),
    ],
  );
}

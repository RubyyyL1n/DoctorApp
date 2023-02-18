import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:sqq_flutter2/components/AppointmentDateSelect.dart';
import 'package:sqq_flutter2/constants.dart';
import 'package:sqq_flutter2/model/PatientDetail.dart';

class MakeAppointment extends StatefulWidget {
  const MakeAppointment({super.key});

  @override
  State<MakeAppointment> createState() => _MakeAppointmentState();
}

class _MakeAppointmentState extends State<MakeAppointment> {

  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Profiles');
  

  String? userName;
  String? userGender;
  String? userEmail;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc('${user?.email}').get(),
      builder: ((context, snapshot) {
        if(snapshot.hasError)
          return Text("Something is wrong");
        if(snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator(color: kBlueColor, backgroundColor: kWhiteColor,),);

        Map<String, dynamic> data = snapshot.data?.data() as Map<String, dynamic>;    
        userName = data['userName'];
        userEmail = data['userEmail'];
        userGender = data['userGender'];

      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).popAndPushNamed('/');
            },
            icon: Icon(Icons.arrow_back, color: kBlackColor800,),
            ),
          title: Text("Book Appointment", style: TextStyle(fontSize: 24, color: kBlackColor800),),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            SizedBox(height: 20,),
            Text('Select Date',
            style: TextStyle(fontSize: 20, color: kBlackColor800),),
            SizedBox(height: 20,),
            DateSelect(),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {
                
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: ((context) => PatientDetail(userName: userName!, userEmail: userEmail!, userGender: userGender!)))
                );
              }, 
              child: Center(
                child: Text(
                  'Next',
                  style: TextStyle(color: kWhiteColor, fontSize: 16, fontWeight: FontWeight.w200),
                ),),
              style: ElevatedButton.styleFrom(
                backgroundColor: kBlueColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
              ),
                )
            ],
          ),
        ),
      );
      
      }
    ));
  }
}
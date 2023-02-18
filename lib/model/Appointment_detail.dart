import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sqq_flutter2/constants.dart';

class AppointmentDetails extends StatefulWidget {
  List<QueryDocumentSnapshot<Object?>> snap;
  int index;
  AppointmentDetails({super.key, required this.snap, required this.index});

  @override
  State<AppointmentDetails> createState() => _AppointmentDetailsState();
}

class _AppointmentDetailsState extends State<AppointmentDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Details', style: TextStyle(fontSize: 24, color: kBlackColor900),),
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back, color: kBlackColor900,)),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20,),
            AppointmentInfo(snap: widget.snap, index: widget.index),
          ]),
      )
    );
  }
}

class AppointmentInfo extends StatefulWidget {
  List<QueryDocumentSnapshot<Object?>> snap;
  int index;
  AppointmentInfo({super.key, required this.snap, required this.index});

  @override
  State<AppointmentInfo> createState() => _AppointmentInfoState();
}

class _AppointmentInfoState extends State<AppointmentInfo> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  image: DecorationImage(image: AssetImage('asset/images/${widget.snap[widget.index]['doctorImage']}')),
                  ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${widget.snap[widget.index]['doctorName']}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: kBlackColor800),
                        ),
                  SizedBox(height: 40,),
                  Text('${widget.snap[widget.index]['doctorSpecialty']}', style: TextStyle(fontSize: 12, color: kBlackColor800),
                  ),
                  SizedBox(height: 20,),
                  Text('${widget.snap[widget.index]['doctorHospital']}', style: TextStyle(fontSize: 12, color: kBlackColor800),
                  )
                ],
              ),
            ],
          ),
           const SizedBox(height: 50),
              
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Name:',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: kBlackColor800),
                          ),
                    Text('${widget.snap[widget.index]['patientName']}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: kGreyColor900),)
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Gender:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800,color: kBlackColor800),
                    ),
                    Text('${widget.snap[widget.index]['patientGender']}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: kGreyColor900)),
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Email:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800,color: kBlackColor800),
                    ),
                    Text('${widget.snap[widget.index]['patientEmail']}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: kGreyColor900)),
                  ],
                )
              ],
            ),
          ),

          const SizedBox(height: 40,),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Date & Time:',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: kBlackColor800),
                          ),
                    Text('${widget.snap[widget.index]['appointmentDate']} | ${widget.snap[widget.index]['appointmentTime']}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: kGreyColor900),)
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Problem:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800,color: kBlackColor800),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Container(
                      height: 200, 
                      width: 400,
                      decoration: BoxDecoration(
                        border: new Border.all(color: Color.fromARGB(255, 0, 0, 0), width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${widget.snap[widget.index]['patientProblem']}',
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800,color: kBlackColor800),),
                      ),
                      ),
                      SizedBox(height: 20,),
              ],
            ),
          )
        ],
      ),
    );
  }
}
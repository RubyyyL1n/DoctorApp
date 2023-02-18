import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqq_flutter2/components/local_notification.dart';
import 'package:sqq_flutter2/components/myNotification.dart';
import 'package:sqq_flutter2/constants.dart';
import 'package:sqq_flutter2/model/makeAppoinment.dart';
import 'package:sqq_flutter2/model/myAppointment.dart';
import 'package:sqq_flutter2/model/providerTest.dart';

class ReviewSummary extends StatefulWidget {
  const ReviewSummary({super.key});

  @override
  State<ReviewSummary> createState() => _ReviewSummaryState();
}

class _ReviewSummaryState extends State<ReviewSummary> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Summary', style: TextStyle(fontSize: 24, color: kBlackColor900),),
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
            DoctorInfo(),
            
          ]),
      )
    );
  }
}

class DoctorInfo extends StatefulWidget {
  const DoctorInfo({super.key});

  @override
  State<DoctorInfo> createState() => _DoctorInfoState();
}

class _DoctorInfoState extends State<DoctorInfo> {
  late final LocalNotificationService service;
  String? userEmail = FirebaseAuth.instance.currentUser!.email;

  @override
  void initState() {
    // TODO: implement initState
    service = LocalNotificationService();
    service.initalize();
    super.initState();
  }

void _showDialog() {
  showDialog(
    context: context, 
    builder: ((context) {
      return AlertDialog(
        title: Text('Congratulations!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: kBlueColor),),
        content: Text('Appointment successfully booked. You will receive a notification and the doctor you selected will contact you soon.', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: kGreyColor700), maxLines: 3,),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: ((context) => MyAppointment())));
            },
            child: Text('View Appointment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: kWhiteColor)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            color: kBlueColor,
            ),
            MaterialButton(
            onPressed: () {
              Navigator.of(context).popAndPushNamed('/');
            },
            child: Text('Cancel', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: kBlueColor)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            color: kWhiteColor,
            ),
            
        ],
      );
    }
    )
  );
}

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
                  image: DecorationImage(image: AssetImage('asset/images/${context.read<SummaryData>().doctorImage}')),
                  ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${context.watch<SummaryData>().doctorName}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: kBlackColor800),
                        ),
                  SizedBox(height: 40,),
                  Text('${context.watch<SummaryData>().doctorSpecialty}', style: TextStyle(fontSize: 12, color: kBlackColor800),
                  ),
                  SizedBox(height: 20,),
                  Text('${context.watch<SummaryData>().doctorHospital}', style: TextStyle(fontSize: 12, color: kBlackColor800),
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
                    Text('${context.watch<SummaryData>().patientName}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: kGreyColor900),)
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Gender:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800,color: kBlackColor800),
                    ),
                    Text('${context.watch<SummaryData>().patientGender}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: kGreyColor900)),
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Email:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800,color: kBlackColor800),
                    ),
                    Text('${context.watch<SummaryData>().patientEmail}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: kGreyColor900)),
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
                    Text('${context.watch<SummaryData>().appointmentDate} | ${context.watch<SummaryData>().appointmentTime}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: kGreyColor900),)
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
                          '${context.read<SummaryData>().patientProblem}',
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800,color: kBlackColor800),),
                      ),
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).popAndPushNamed('makeAppointment');
                            }, 
                            child: Text('Rescheduled', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800,color: kBlackColor800) ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kGreyColor900,
                              shadowColor: kGreyColor900,
                              elevation: 3,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              _showDialog();
                              context.read<SummaryData>().createAppointment();
                              context.read<MyNotification>().ApproveNotification(
                                context.read<SummaryData>().doctorName!, 
                                context.read<SummaryData>().appointmentDate!, 
                                context.read<SummaryData>().appointmentTime!);
                              context.read<MyNotification>().setEmail(userEmail!);
                              context.read<MyNotification>().createNotification();
                              await service.showNotification(id: 0, title: 'You have a new schedule!', body: 'Your reservation processes successfully, Please wait until the doctor accept the requestion');
                            }, 
                            child: Text('Schedule', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800,color: kWhiteColor) ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kBlueColor,
                              shadowColor: kBlueColor,
                              elevation: 3,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                        ],
                      )
              ],
            ),
          )
        ],
      ),
    );
  }
}






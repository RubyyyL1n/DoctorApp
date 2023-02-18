import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqq_flutter2/components/patientReview.dart';
import 'package:sqq_flutter2/constants.dart';
import 'package:sqq_flutter2/model/Appointment_detail.dart';
import 'package:sqq_flutter2/model/appointment_cancel.dart';
import 'package:sqq_flutter2/model/makeAppoinment.dart';
import 'package:sqq_flutter2/model/providerTest.dart';
import 'package:sqq_flutter2/model/review.dart';



class MyAppointment extends StatefulWidget {
  const MyAppointment({super.key});

  @override
  State<MyAppointment> createState() => _MyAppointmentState();
}

class _MyAppointmentState extends State<MyAppointment> with SingleTickerProviderStateMixin{
  final List<Tab> myTabs = <Tab> [
    Tab(child: Text('Upcoming', style: TextStyle(color: kWhiteColor, fontSize: 16),)),
    Tab(child: Text('Completed', style: TextStyle(color: kWhiteColor, fontSize: 16),)),
    Tab(child: Text('Cancel', style: TextStyle(color: kWhiteColor, fontSize: 16),)),
  ];
  late TabController _controller;
  

  @override
  void initState() {
    _controller = TabController(length: myTabs.length, vsync: this);
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: myTabs.length,
        child: Scaffold(
          appBar: AppBar(
        backgroundColor: kGreenColor,
        elevation: 4,
        shadowColor: kBlackColor800,
        leading: IconButton(
          onPressed:() {
            Navigator.of(context).popAndPushNamed('settings');
          },
          icon: Icon(Icons.arrow_back, color: kWhiteColor,)),
          title: Text(
            'My Appointment',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, color: kWhiteColor),
          ),
          bottom: TabBar(
            indicatorColor: kBlueColor,
            controller: _controller,
            tabs: myTabs,
            padding: EdgeInsets.symmetric(horizontal: 4),
            ),
      ),
      body: TabBarView(
        dragStartBehavior: DragStartBehavior.down,
        controller: _controller,
        children: [
          UpcomingInfo(),
          CompletedInfo(),
          CancelInfo(),
        ],
        ),
        ),
        )
    );
  }
}


class CompletedInfo extends StatefulWidget {
  CompletedInfo({super.key});

  @override
  State<CompletedInfo> createState() => _CompletedInfoState();
}

class _CompletedInfoState extends State<CompletedInfo> {

  final _controller = ScrollController();
  final appointmentRef = FirebaseFirestore
        .instance
        .collection('Appointments')
        .where("patientEmail", isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .where("appointmentStatus", isEqualTo: 'Complete')
        .snapshots();


  void _bookAgain(List<QueryDocumentSnapshot<Object?>> snap, int index) {
  showDialog(
        context: context,
        builder: (context) {
        return AlertDialog(
        title: const Text('Do you want to book this doctor again ?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: kGreenColor),),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            color: kGreenColor,
            child: const Text('No', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: kWhiteColor)),
            ),
            MaterialButton(
            onPressed: () {
              context.read<SummaryData>()
              .assignDoctor(snap[index]['doctorName'], 
              snap[index]['doctorSpecialty'], 
              snap[index]['doctorHospital'], 
              snap[index]['doctorImage']);
              Navigator.push(context, MaterialPageRoute(builder: ((context) => MakeAppointment())));
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            color: kWhiteColor,
            child: const Text('Yes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: kGreenColor)),
            ),
        ],
      );
        }
  );
}

@override
void initState() {
    // TODO: implement initState
    _controller.addListener(() {
      if(_controller.position.maxScrollExtent == _controller.offset) {}
     });
    super.initState();
  }
  
@override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: StreamBuilder<QuerySnapshot> (
        stream: appointmentRef,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.hasData) {
            final snap = snapshot.data!.docs;
            return ListView.builder(
              scrollDirection: Axis.vertical,
              controller: _controller,
              shrinkWrap: true,
              itemCount: snap.length,
              itemBuilder: ((context, index) {
                return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                    Container(
                    height: 140,
                    width: 140,
                    decoration: BoxDecoration(image: DecorationImage(image: AssetImage('asset/images/${snap[index]['doctorImage']}'))),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          snap[index]['doctorName']!, 
                          style: TextStyle(fontSize: 16, color: kBlackColor800),
                          ),
                          SizedBox(height: 8,),
                              Row(
                                children: [
                                  Text('Messaging',
                                  style: TextStyle(fontSize: 12, color: kGreyColor800),),
                                  SizedBox(width: 20,),
                                  Container(
                                    height: 20,
                                    width: 80,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
                                    child: Text('Completed', style: TextStyle(fontSize: 14, color: kBlueColor),),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10,),
                              Text('${snap[index]['appointmentDate']}'),
                            ],
                          ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40))),
                          onPressed: () {
                            _bookAgain(snap, index);
                          }, 
                            child: Text('Book Again',
                            style: TextStyle(fontSize: 14, color: kGreenColor),
                            textAlign: TextAlign.center,
                            ),
                            ),  
                            ElevatedButton(
                          onPressed: () {
                            context.read<Review>().setDoctor(snap[index]['doctorName'], snap[index]['appointmentID'], snap[index]['patientName'], snap[index]['appointmentStatus']);
                            Navigator.push(context, MaterialPageRoute(builder: ((context) => MyReview(doctorImage: snap[index]['doctorImage'],))));
                          }, 
                          style: ElevatedButton.styleFrom(backgroundColor: kGreenColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40))),
                            child: Text('Leave a Review',
                            style: TextStyle(fontSize: 16, color: kWhiteColor),
                            ),
                            
                            )
                      ],
                    )
                ],
              );
              }),
            );
          }else {
            return SizedBox();
          }
        }), 
      );

      }
      
  }

class CancelInfo extends StatefulWidget {
  CancelInfo({super.key});

  @override
  State<CancelInfo> createState() => _CancelInfoState();
}

class _CancelInfoState extends State<CancelInfo> {

  final _controller = ScrollController();
  final appointmentRef = FirebaseFirestore
  .instance
  .collection('Appointments')
  .where("patientEmail", isEqualTo: FirebaseAuth.instance.currentUser!.email)
  .where("appointmentStatus", isEqualTo: 'Cancel')
  .snapshots();

  @override
  void initState() {
    // TODO: implement initState
    _controller.addListener(() {
      if(_controller.position.maxScrollExtent == _controller.offset) {}
     });
    super.initState();
  }

  void _showDeleteDialog(List<QueryDocumentSnapshot<Object?>> snap, int index) {
  showDialog(
    context: context, 
    builder: ((context) {
      return AlertDialog(
        title: Text('Are you sure to delete the history appointment?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: kGreenColor),),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('No', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: kWhiteColor)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            color: kGreenColor,
            ),
            MaterialButton(
            onPressed: () {
              FirebaseFirestore
              .instance
              .collection('Appointments')
              .doc('${snap[index]['appointmentID']}')
              .delete();
              Navigator.pop(context);
            },
            child: Text('Yes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: kGreenColor)),
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
      padding: EdgeInsets.all(20),
      child: StreamBuilder<QuerySnapshot> (
        stream: appointmentRef,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.hasData) {
            final snap = snapshot.data!.docs;
            print('${snap.length}');
            return ListView.builder(
              controller: _controller,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snap.length,
              itemBuilder: ((context, index) {
                return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                    Container(
                    height: 140,
                    width: 140,
                    decoration: BoxDecoration(image: DecorationImage(image: AssetImage('asset/images/${snap[index]['doctorImage']}'))),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          snap[index]['doctorName']!, 
                          style: TextStyle(fontSize: 16, color: kBlackColor800),
                          ),
                          SizedBox(height: 8,),
                              Row(
                                children: [
                                  Text('Messaging',
                                  style: TextStyle(fontSize: 12, color: kGreyColor800),),
                                  SizedBox(width: 20,),
                                  Container(
                                    height: 20,
                                    width: 80,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
                                    child: Text('Cancelled', style: TextStyle(fontSize: 14, color: kBlueColor),),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10,),
                              Text('${snap[index]['appointmentDate']}'),
                            ],
                          ),

                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                                onPressed: () {
                                  _showDeleteDialog(snap, index);
                                }, 
                                style: ElevatedButton.styleFrom(backgroundColor: kGreenColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40))),
                                  child: Text('Delete history',
                                  style: TextStyle(fontSize: 16, color: kWhiteColor),
                                  ),
                                  
                                  ),
                      ],
                    )
                ],
              );
              }),
            );
          }else {
            return SizedBox();
          }
        }), 
      );

      }
      
  }




class UpcomingInfo extends StatefulWidget {
  UpcomingInfo({super.key});

  @override
  State<UpcomingInfo> createState() => _UpcomingInfoState();
}

class _UpcomingInfoState extends State<UpcomingInfo> {

  final _controller = ScrollController();
  final userEmail = FirebaseAuth.instance.currentUser!.email;
  final appointmentRef = FirebaseFirestore
                .instance
                .collection('Appointments')
                .where("patientEmail", isEqualTo: FirebaseAuth.instance.currentUser!.email,)
                .where("appointmentStatus", whereIn: ['Accept', 'Under process'])
                .snapshots();

void _showCancelDialog(List<QueryDocumentSnapshot<Object?>> snap, int index) {
  showDialog(
    context: context, 
    builder: ((context) {
      return AlertDialog(
        title: Text('Are you sure to cancel the appointment?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: kGreenColor),),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('No', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: kWhiteColor)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            color: kGreenColor,
            ),
            MaterialButton(
            onPressed: () {
              
              Navigator.push(context, MaterialPageRoute(builder: ((context) => CancelAppointment(snap: snap, index: index, userEmail: userEmail!,))));
            },
            child: Text('Yes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: kGreenColor)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            color: kWhiteColor,
            ),
        ],
      );
    }
    )
    );
    }

  void _reschedule(List<QueryDocumentSnapshot<Object?>> snap, int index) {
  showDialog(
        context: context,
        builder: (context) {
        return AlertDialog(
        title: const Text('Are you sure to change your schedule?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: kGreenColor),),
        content: const Text('Once you decide to reschedule, the origin schedule will be cancel', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: kBlackColor800),),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            color: kGreenColor,
            child: const Text('No', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: kWhiteColor)),
            ),
            MaterialButton(
            onPressed: () {
              context.read<SummaryData>()
              .assignDoctor(snap[index]['doctorName'], 
              snap[index]['doctorSpecialty'], 
              snap[index]['doctorHospital'], 
              snap[index]['doctorImage']);
              FirebaseFirestore.instance
                              .collection('Appointments')
                              .doc('${snap[index]['appointmentID']}')
                              .delete();
              Navigator.push(context, MaterialPageRoute(builder: ((context) => MakeAppointment())));
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            color: kWhiteColor,
            child: const Text('Yes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: kGreenColor)),
            ),
        ],
      );
        }
  );
}


  @override
  void initState() {
    // TODO: implement initState
    _controller.addListener(() {
      if(_controller.position.maxScrollExtent == _controller.offset) {}
     });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: StreamBuilder<QuerySnapshot> (
        stream: appointmentRef,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.hasData) {
            final snap = snapshot.data!.docs;
            return ListView.builder(
              controller: _controller,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snap.length,
              itemBuilder: ((context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AppointmentDetails(snap: snap, index: index)));
                  },
                  child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      Container(
                      height: 140,
                      width: 140,
                      decoration: BoxDecoration(image: DecorationImage(image: AssetImage('asset/images/${snap[index]['doctorImage']}'))),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            snap[index]['doctorName']!, 
                            style: TextStyle(fontSize: 16, color: kBlackColor800),
                            ),
                            SizedBox(height: 8,),
                                Row(
                                  children: [
                                    Text('Messaging',
                                    style: TextStyle(fontSize: 12, color: kGreyColor800),),
                                    SizedBox(width: 20,),
                                    Container(
                                      height: 20,
                                      width: 120,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
                                      child: Text('${snap[index]['appointmentStatus']}', style: TextStyle(fontSize: 14, color: kBlueColor),),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Text('${snap[index]['appointmentDate']}'),
                              ],
                            ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40))),
                            onPressed: () {
                              _showCancelDialog(snap, index);
                            }, 
                              child: Text('Cancel Appointment',
                              style: TextStyle(fontSize: 14, color: kGreenColor),
                              textAlign: TextAlign.center,
                              ),
                              ),  
                              ElevatedButton(
                            onPressed: () {
                              _reschedule(snap, index);

                            }, 
                            style: ElevatedButton.styleFrom(backgroundColor: kGreenColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40))),
                              child: Text('Reschedule',
                              style: TextStyle(fontSize: 16, color: kWhiteColor),
                              ),
                              
                              )
                        ],
                      )
                  ],
                  ),
                );
              }),
            );
          }else {
            return const SizedBox();
          }
        }), 
      );

      }
      
  }






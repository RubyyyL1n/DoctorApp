import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sqq_flutter2/constants.dart';


class CancelSelection {
  final String reason;
  bool isSelected;
  
  CancelSelection(this.reason, this.isSelected);
}


class DoctorAppointment extends StatefulWidget {
  const DoctorAppointment({super.key});

  @override
  State<DoctorAppointment> createState() => _DoctorAppointmentState();
}

class _DoctorAppointmentState extends State<DoctorAppointment> {
  // ignore: prefer_typing_uninitialized_variables
  String name = '';
  final _controller = ScrollController();
  final ref = FirebaseFirestore.instance.collection("Appointments");

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
    return StreamBuilder<QuerySnapshot>(
        stream: ref
        .where("doctorName", isEqualTo: 'dr. Gilang Segara Bening')
        .where("appointmentStatus", whereIn: ['Under process', 'Accept'])
        .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          final snap = snapshot.data?.docs;
          if(snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const SizedBox(height: 20,),
                  TextField(
                    onChanged: ((value) {
                      setState(() {
                        name = value;
                      });
                    }),
                    decoration: InputDecoration(
                      labelText: 'Search (patient name, appointment status)',
                      suffixIcon: Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 20,),
                   ListView.builder(
                    controller: _controller,
                      shrinkWrap: true,
                      itemCount: snap.length,
                      itemBuilder: (context, index) {
                        var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                        if(name.isEmpty)
                        {
                          return Column(
                            children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                              Container(
                              height: 140,
                              width: 140,
                              decoration: BoxDecoration(image: DecorationImage(image: AssetImage('asset/images/${data['doctorImage']}'))),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['patientName']!, 
                                    style: TextStyle(fontSize: 16, color: kBlackColor800),
                                    ),
                                    const SizedBox(height: 8,),
                                        Row(
                                          children: [
                                            const Text('Messaging',
                                            style: TextStyle(fontSize: 12, color: kGreyColor800),),
                                            const SizedBox(width: 20,),
                                            Container(
                                              height: 20,
                                              width: 120,
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
                                              child: Text('${data['appointmentStatus']}', style: TextStyle(fontSize: 14, color: kBlueColor),),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        Text('${data['appointmentDate']}', style: TextStyle(fontSize: 14, color: kBlackColor900, fontWeight: FontWeight.w800),),
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
                                      Navigator.push(context, MaterialPageRoute(builder: ((context) => DoctorCancel(snap: snap, index: index))));
                                    }, 
                                      child: Text('Cancel Appoitnment',
                                      style: TextStyle(fontSize: 14, color: kGreenColor),
                                      textAlign: TextAlign.center,
                                      ),
                                      ),  
                                      ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: ((context) => CheckAppoitment(snap: snap, index: index))));
                                    }, 
                                    style: ElevatedButton.styleFrom(backgroundColor: kGreenColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40))),
                                      child: Text('Check Appointment',
                                      style: TextStyle(fontSize: 16, color: kWhiteColor),
                                      ),
                                      
                                      )
                                ],
                              )
                          ],
                        );

                        }
                        if(data['patientName'].toString().toLowerCase().startsWith(name.toLowerCase())
                        || data['appointmentStatus'].toString().toLowerCase().startsWith(name.toLowerCase())
                        ) {
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snap[index]['patientName']!, 
                                    style: TextStyle(fontSize: 16, color: kBlackColor800),
                                    ),
                                    const SizedBox(height: 8,),
                                        Row(
                                          children: [
                                            const Text('Messaging',
                                            style: TextStyle(fontSize: 12, color: kGreyColor800),),
                                            const SizedBox(width: 20,),
                                            Container(
                                              height: 20,
                                              width: 120,
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
                                              child: Text('${snap[index]['appointmentStatus']}', style: TextStyle(fontSize: 14, color: kBlueColor),),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        Text('${snap[index]['appointmentDate']}', style: TextStyle(fontSize: 14, color: kBlackColor900, fontWeight: FontWeight.w800),),
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
                                      Navigator.push(context, MaterialPageRoute(builder: ((context) => DoctorCancel(snap: snap, index: index))));
                                    }, 
                                      child: Text('Cancel Appoitnment',
                                      style: TextStyle(fontSize: 14, color: kGreenColor),
                                      textAlign: TextAlign.center,
                                      ),
                                      ),  
                                      ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: ((context) => CheckAppoitment(snap: snap, index: index))));
                                    }, 
                                    style: ElevatedButton.styleFrom(backgroundColor: kGreenColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40))),
                                      child: Text('Check Appointment',
                                      style: TextStyle(fontSize: 16, color: kWhiteColor),
                                      ),
                                      
                                      )
                                ],
                              )
                          ],
                        );
                        }
                        return Container();
                      }
                      ),
                ],
              ),
            );
          }
          return SizedBox();
        }
        
        );

  }
}

class CheckAppoitment extends StatefulWidget {
  List<QueryDocumentSnapshot<Object?>> snap;
  int index;
  CheckAppoitment({super.key, required this.snap, required this.index});

  @override
  State<CheckAppoitment> createState() => _CheckAppoitmentState();
}

class _CheckAppoitmentState extends State<CheckAppoitment> {

  
  void _ApprovelDialog() {
  showDialog(
    context: context, 
    builder: ((context) {
      return AlertDialog(
        title: Text('Approve Successfully!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: kGreenColor),),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

        actions: [
            MaterialButton(
            onPressed: () {
              Navigator.of(context).popAndPushNamed('admin');
            },
            child: Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: kGreenColor)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            color: kWhiteColor,
            ),
        ],
      );
    }
    )
    );
    }

  void _SelectDialog() {
  showDialog(
    context: context, 
    builder: ((context) {
      return AlertDialog(
        title: Text('The duration has been booked by other customers', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: kGreenColor),),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

        actions: [
            MaterialButton(
            onPressed: () {
              Navigator.of(context).popAndPushNamed('admin');
            },
            child: Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: kGreenColor)),
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
    final ref = FirebaseFirestore.instance.collection('Time');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kGreenColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back, color: kWhiteColor,)),
          title: const Text('Appointment Details', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: kWhiteColor),),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: ref.doc(widget.snap[widget.index]['appointmentDate']).snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
          Map<String, dynamic> docSnap = snapshot.data?.data() as Map<String, dynamic>;
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
                            Container(
                              height: 40,
                              width: 400,
                              child: ElevatedButton(
                                onPressed: () => docSnap[widget.snap[widget.index]['appointmentTime']] == false ?
                                {
                                  FirebaseFirestore
                                  .instance
                                  .collection('Appointments')
                                  .doc('${widget.snap[widget.index]['appointmentID']}')
                                  .update({"appointmentStatus": 'Accept'}),

                                  FirebaseFirestore
                                  .instance
                                  .collection('Time')
                                  .doc(docSnap['appointmentDate'])
                                  .update({widget.snap[widget.index]['appointmentTime']: true}),
                                  _ApprovelDialog(),
                                
                                }
                                : {
                                  _SelectDialog(),
                                }, 
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kGreenColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                ),
                                child: Text('Approve', style: TextStyle(fontSize: 24, color: kWhiteColor, fontWeight: FontWeight.w700),)),
                            ),
                    ],
                  ),
                )
              ],
            ),
          );
          }
          else if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          else {
            return SizedBox();
          }
        }
      ),
    );
  }
}



class DoctorCancel extends StatefulWidget {
  List<QueryDocumentSnapshot<Object?>> snap;
  int index;
  DoctorCancel({super.key,required this.snap, required this.index});

  @override
  State<DoctorCancel> createState() => _DoctorCancelState();
}

class _DoctorCancelState extends State<DoctorCancel> {
  List<CancelSelection> selection = [
    CancelSelection('Patient information is not available', false),
    CancelSelection('Time/Duration is not available', false),
    CancelSelection('Doctor is not available', false),
    CancelSelection('Patient\'s problem has been solved', false),
    CancelSelection('Others', false),
  ];

  void _DoctorCancelDialog() {
  showDialog(
    context: context, 
    builder: ((context) {
      return AlertDialog(
        title: Text('Cancel Successfully!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: kGreenColor),),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

        actions: [
            MaterialButton(
            onPressed: () {
              Navigator.of(context).popAndPushNamed('admin');
            },
            child: Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: kGreenColor)),
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
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).popAndPushNamed('admin');
          },
          icon: Icon(Icons.arrow_back, color: kWhiteColor,), iconSize: 20,
          ),
          title: const Text(
            'Cancel Appointment',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, color: kWhiteColor),
          ),
          backgroundColor: kGreenColor,
          shadowColor: kGreenColor,
      ),
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 18,),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('Reason for cancel appointment', style: TextStyle(fontSize: 20, color: kBlackColor800, fontWeight: FontWeight.w900),),
                ),
                ListView.builder(
                  itemCount: selection.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, index) {
                    return selectItem(selection: selection, index: index,);
                  }),
                const SizedBox(height: 20,),
                 TextField(
                    enabled: true,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Please specify your reason...',
                      hintStyle: TextStyle(fontSize: 16),
                      fillColor: kGreyColor400,
                      filled: true,
                      border: InputBorder.none,
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    width: 400,
                    height: 30,
                    padding: EdgeInsets.only(left: 8),
                    child: ElevatedButton(
                                    onPressed: () async {
                                      FirebaseFirestore.instance
                                      .collection('Appointments')
                                      .doc('${widget.snap[widget.index]['appointmentID']}')
                                      .update({"appointmentStatus": 'Cancel'});

                                      if(widget.snap[widget.index]['appointmentStatus'] == 'Accept')
                                      {
                                        FirebaseFirestore
                                      .instance
                                      .collection('Time')
                                      .doc('${widget.snap[widget.index]['appointmentDate']}')
                                      .update({widget.snap[widget.index]['appointmentTime']: false});
                                      }

                                      _DoctorCancelDialog();
                                    }, 
                                    child: Text('Submit', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800,color: kWhiteColor) ),
                                    style: ElevatedButton.styleFrom(
                                      
                                      backgroundColor: kGreenColor,
                                      shadowColor: kGreenColor,
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    ),
                                  ),
                  ),
                    ],
                  ),
          ),
          ),
        ),
      );
  }
}

class selectItem extends StatefulWidget {
  List<CancelSelection> selection;
  int index;
  selectItem({super.key, required this.selection, required this.index});

  @override
  State<selectItem> createState() => _selectItemState();
}

class _selectItemState extends State<selectItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
    title: Text('${widget.selection[widget.index].reason}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),),
    trailing: widget.selection[widget.index].isSelected ? Icon(Icons.circle, color: kGreenColor,) : Icon(Icons.circle, color: kGreyColor700,),
    onTap: () {
     setState(() {
       widget.selection[widget.index].isSelected = !widget.selection[widget.index].isSelected;
     });
    },
  );
  }
}
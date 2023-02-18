import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqq_flutter2/components/local_notification.dart';
import 'package:sqq_flutter2/components/myNotification.dart';
import 'package:sqq_flutter2/components/patientReview.dart';
import 'package:sqq_flutter2/constants.dart';



class CancelSelection {
  final String reason;
  bool isSelected;
  
  CancelSelection(this.reason, this.isSelected);
}


class CancelAppointment extends StatefulWidget {
  final snap;
  final index;
  String userEmail;
  CancelAppointment({super.key, required this.snap, required this.index, required this.userEmail});

  @override
  State<CancelAppointment> createState() => _CancelAppointmentState();
}

class _CancelAppointmentState extends State<CancelAppointment> {

  late final LocalNotificationService service;
  final controller = TextEditingController();
  List<CancelSelection> selection = [
    CancelSelection('I want to change to another doctor', false),
    CancelSelection('I want to change another date', false),
    CancelSelection('I want to change to another duration', false),
    CancelSelection('I have recovered from the disease', false),
    CancelSelection('I just want to cancel', false),
    CancelSelection('I have found a suitable medicine', false),
    CancelSelection('Others', false),
  ];

  @override
  void initState() {
    // TODO: implement initState
    service = LocalNotificationService();
    service.initalize();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

void _showDialog() {
  showDialog(
    context: context, 
    builder: ((context) {
      return AlertDialog(
        title: Text('You have cancel the Appointment!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: kGreenColor),),
        content: Text('We are very sorry that you have cancelled your appointment. We will always imporve our service to satisfy you in the next appointment.', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: kGreyColor700), maxLines: 3,),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.of(context).popAndPushNamed('myappointment');
            },
            child: Text('Ok', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: kWhiteColor)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            color: kGreenColor,
            ),
            
        ],
      );
    }
    )
  );
}

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back, color: kWhiteColor,), iconSize: 20,
          ),
          title: Text(
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
                  child: Text('Reason for schedule change', style: TextStyle(fontSize: 20, color: kBlackColor800, fontWeight: FontWeight.w900),),
                ),
                ListView.builder(
                  itemCount: selection.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, index) {
                    return selectItem(selection: selection, index: index,);
                  }),
                const SizedBox(height: 20,),
                 TextField(
                    controller: controller,
                    enabled: true,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Please input your reason...',
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
                                      if(controller.text.isEmpty)
                                      {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                        content: Text('Require one selection and specify the reason', style: TextStyle(color: kRedColor,)),
                                        duration: Duration(seconds: 2), 
                                        )
                                        ); 
                                      }
                                      else{
                                      FirebaseFirestore.instance
                                      .collection('Appointments')
                                      .doc('${widget.snap[widget.index]['appointmentID']}')
                                      .update({"appointmentStatus": 'Cancel'});
                                      context.read<Review>().setDoctor(widget.snap[widget.index]['doctorName'], widget.snap[widget.index]['appointmentID'], widget.snap[widget.index]['patientName'], 'Cancel');
                                      context.read<Review>().setReview(controller.text, 0);
                                      context.read<Review>().createReviews();
                                      context.read<MyNotification>().CancelNotification(
                                      widget.snap[widget.index]['doctorName'],
                                      widget.snap[widget.index]['appointmentDate'],
                                      widget.snap[widget.index]['appointmentTime']);
                                      context.read<MyNotification>().setEmail(widget.userEmail);
                                      context.read<MyNotification>().createNotification();
                                      if(widget.snap[widget.index]['appointmentStatus'] == 'Accept')
                                      {
                                        FirebaseFirestore
                                      .instance
                                      .collection('Time')
                                      .doc('${widget.snap[widget.index]['appointmentDate']}')
                                      .update({"${widget.snap[widget.index]['appointmentTime']}": false});
                                      }
                                      
                                      _showDialog();
                                      await service.showNotification(id: 0, title: 'You have cancel the appointment', body: 'Thank you for your review, and hope you can satisfy with our service next time');
                                      }
                                      
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
       context.read<Review>().setPatientOption(widget.selection[widget.index].reason);
     });
    },
  );
  }
}
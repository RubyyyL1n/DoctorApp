import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sqq_flutter2/components/doctorTime.dart';
import 'package:sqq_flutter2/constants.dart';
import 'package:table_calendar/table_calendar.dart';


class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime selectDate = DateTime.now();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  String? selDate;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  Map<String, List> mySelectedEvents = {};
  int? currentYear;
  int? currentMonth;
  int? currentDay;
  var firstDate;
  var lastDate;
  Map<String, List> id = {};
  final ref = FirebaseFirestore
  .instance
  .collection('Appointments')
  .where('doctorName', isEqualTo: 'dr. Gilang Segara Bening')
  .where('appointmentStatus', isEqualTo: 'Accept');
  late Widget workShift;
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      selectDate = day;
      selDate = formatDate(selectDate, [M,' ',dd, ',',yyyy]).toString(); 
      workShift = AddWorkShift(selDate: selDate!);
    });
  }


  _showAddDialog() async{
    await showDialog(
      context: context,
      builder: ((context) => AlertDialog(
        title: const Text(
          'Add New Event',
          textAlign: TextAlign.center,
        ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: 'Title',
            ),
          ),
          TextField(
            controller: descriptionController,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: 'Description',
            ),
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          }, 
          child: const Text('Cancel')
          ),
          TextButton(
          onPressed: () {
            if(titleController.text.isEmpty && descriptionController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Require title and description', style: TextStyle(color: kRedColor,)),
                  duration: Duration(seconds: 2), 
                  )
              );
            }
            else {
              setState(() {

                if(mySelectedEvents[formatDate(selectDate, [M,' ',dd, ',',yyyy])] != null) {
                  mySelectedEvents[formatDate(selectDate, [M,' ',dd, ',',yyyy])]?.add({
                      'eventTitle': titleController.text,
                      'eventDescp': descriptionController.text,
                    });

                } else{
                    mySelectedEvents[formatDate(selectDate, [M,' ',dd, ',',yyyy])] = [{
                      'eventTitle': titleController.text,
                      'eventDescp': descriptionController.text,
                    }
                    ];
                }
                titleController.clear();
                descriptionController.clear();
                Navigator.pop(context);
                return;
              }
              );
                

            }
          }, 
          child: const Text('Add Event')
          ),
      ],
      )
      )
      );
  }

  List _listofDayEvents(DateTime dateTime) {
    if(mySelectedEvents[formatDate(dateTime, [M,' ',dd, ',',yyyy])] != null) {
      return mySelectedEvents[formatDate(dateTime, [M,' ',dd, ',',yyyy])]!;
    }else {
      return [];
    }
  }

  // ignore: non_constant_identifier_names
  _showCompleteDialog(List appointmentID, String eventTitle, String eventDescp) async {
    showDialog(
    context: context, 
    builder: ((context) {
      return AlertDialog(
        title: Text('Are you sure to complete this appointment?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: kGreenColor),),
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

              for(int i = 0; i<appointmentID.length; i++)
              {
                if(appointmentID[i]['patientName'] == eventTitle && appointmentID[i]['appointmentDuration'] == eventDescp) {
                  FirebaseFirestore.instance.collection('Appointments').doc(appointmentID[i]['appointmentID']).update({'appointmentStatus': 'Complete'});
                }
              }
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
  void initState() {
    super.initState();
    // TODO: implement initState
    currentYear = selectDate.year;
    currentMonth = selectDate.month;
    currentDay = selectDate.day;
    firstDate = DateTime(currentYear!, currentMonth!, currentDay!);
    if(currentMonth! == 11) {
      lastDate = DateTime(currentYear!+1, 12-currentMonth!+2);
    }
    else if (currentMonth! == 12) {
      lastDate = DateTime(currentYear!+1, 12-currentMonth!+3);
    }
     else {
      lastDate = DateTime(currentYear!, currentMonth!+3);
    }
    addToEvent();
    
  }

 void addToEvent() {
    ref.get().then((value) {
      value.docs.forEach((element) {
        String Date = element['appointmentDate'];
        String title = element['patientName'];
        String descp = element['appointmentTime'];
        String appointmentid = element['appointmentID'];
        setState(() {
          if(mySelectedEvents[Date] != null) {
              mySelectedEvents[Date]?.add({
                  'eventTitle': title,
                  'eventDescp': descp,
            });
            id[Date]?.add({
              'patientName': title,
              'appointmentID': appointmentid,
              'appointmentDuration': descp,
            });
        }else {
              mySelectedEvents[Date] = [{
                  'eventTitle': title,
                  'eventDescp': descp,
            }];
              id[Date] = [{
              'patientName': title,
              'appointmentID': appointmentid,
              'appointmentDuration': descp,
              }];
        }
        });   
      });
    });

 }

  @override
  Widget build(BuildContext context) {
          return StreamBuilder<QuerySnapshot>(
            stream: ref.snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if(snapshot.hasData){
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TableCalendar(
                      calendarFormat: _calendarFormat,
                      focusedDay: selectDate,
                      firstDay: firstDate, 
                      lastDay: lastDate,
                      onDaySelected: _onDaySelected,
                      availableGestures: AvailableGestures.all,
                      selectedDayPredicate: (day) => isSameDay(day, selectDate),
                      onFormatChanged: (format) {
                        setState(() {
                          _calendarFormat = format;
                        }
                        );
                      },
                      eventLoader: _listofDayEvents,
                      ),
                    
                   const  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // ignore: unnecessary_null_comparison
                      if(selDate != null)
                        workShift,
                    ],
                    ),
                    
                    ..._listofDayEvents(selectDate).map(
                        (myEvent) => ListTile(
                          leading: IconButton(
                            icon: Icon(Icons.done), color: Colors.teal,
                            onPressed: () => selectDate.compareTo(DateTime.now()) <= 0
                            && formatDate(DateTime.now(), [HH,':',mm]).compareTo(myEvent['eventDescp'].substring(0,5)) >= 0 
                            ? {
                              _showCompleteDialog(id[formatDate(selectDate, [M,' ',dd, ',',yyyy])]!, myEvent['eventTitle'], myEvent['eventDescp']),
                            } : {
                              ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                        content: Text('This event cannot be completed, since it haven\'t started yet.', style: TextStyle(color: kRedColor,)),
                                        duration: Duration(seconds: 2), 
                                        )
                                        ),
                            }
                            ),
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text('${myEvent['eventTitle']}'),
                          ),
                          subtitle: Text('${myEvent['eventDescp']}', style: TextStyle(fontSize: 14),),
                        )),
                  ],
                );
                }
                else if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator(),);
              }
              return const SizedBox();
                }
                
                );
            }
        }

class AddWorkShift extends StatefulWidget {
  // ignore: non_constant_identifier_names
  String selDate;
  // ignore: non_constant_identifier_names
  AddWorkShift({super.key, required this.selDate});

  @override
  State<AddWorkShift> createState() => _AddWorkShiftState();
}

class _AddWorkShiftState extends State<AddWorkShift> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<TimeSelection>().initiateDate(widget.selDate);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: kBlueColor,
        shadowColor: kBlueColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(90)),
      ), 
      child: const Icon(Icons.add),
    );
  }
}
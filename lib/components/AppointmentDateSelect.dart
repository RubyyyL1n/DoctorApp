import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqq_flutter2/constants.dart';
import 'package:sqq_flutter2/model/providerTest.dart';

// ignore: constant_identifier_names
enum DurationTime {
  DURATION1, 
  DURATION2,
  DURATION3, 
  DURATION4, 
  DURATION5, 
  DURATION6, 
  DURATION7, 
  DURATION8, 
  DURATION9, 
  DURATION10, 
  DURATION11, 
  DURATION12,}

class DateSelect extends StatefulWidget {
  const DateSelect({super.key});

  @override
  State<DateSelect> createState() => _DateSelectState();
}

class _DateSelectState extends State<DateSelect> {
  late Widget timeSelect;
  DateTime selectDate = DateTime.now();
  int? currentYear;
  int? currentMonth;
  int? currentDay;
  // ignore: prefer_typing_uninitialized_variables
  var firstDate;
  // ignore: prefer_typing_uninitialized_variables
  var lastDate;
  String? date;

  @override
  void initState() {
    super.initState();
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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: kGreenLightColor),
            child: CalendarDatePicker(
                initialDate: selectDate,
                firstDate: firstDate,
                lastDate: lastDate,
                onDateChanged: (newDate) {
                  setState(() {   
                    date = formatDate(newDate, [M,' ',dd, ',',yyyy]).toString();
                    print(date);
                    context.read<SummaryData>().assignAppointmentDate(date!);
                    timeSelect = TimeSelect(selectDate: date!);
                  });
                },          
              ),
        ),
        const SizedBox(height: 30,),
        const Text('Select Time',
        style: TextStyle(fontSize: 20, color: kBlackColor800),),
        const SizedBox(height: 20,),
        if(date != null)
          timeSelect,
      ],
    );
  }
}

class TimeSelect extends StatefulWidget {
  String selectDate;
  TimeSelect({super.key, required this.selectDate});

  @override
  State<TimeSelect> createState() => _TimeSelectState();
}

class _TimeSelectState extends State<TimeSelect> {
  DurationTime? _durationTime;
  final ref = FirebaseFirestore.instance.collection('Time');

  void _AlarmDialog() {
  showDialog(
    context: context, 
    builder: ((context) {
      return AlertDialog(
        title: Text('The duration has been booked by other customers', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: kGreenColor),),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

        actions: [
            MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
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

    void _OffShiftDialog() {
  showDialog(
    context: context, 
    builder: ((context) {
      return AlertDialog(
        title: Text('Sorry, the date you select is not within the duty time', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: kGreenColor),),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

        actions: [
            MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
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
    return FutureBuilder<DocumentSnapshot>(
      future: ref.doc(widget.selectDate).get(),
      builder: (context, snapshot) {
        if(snapshot.hasData)
        {
          Map<String, dynamic> docSnap = snapshot.data?.data() as Map<String, dynamic>;
          return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: RadioListTile<DurationTime>(
                    value: DurationTime.DURATION1, 
                    groupValue: _durationTime, 
                    onChanged: (val) =>
                    docSnap['09:00 AM'] == false ?
                    {
                      setState(() {
                        _durationTime = val;
                        context.read<SummaryData>().assignAppointmentTime('09:00 AM');
                      }),
                    }
                    : {
                      _AlarmDialog(),
                    },
                    dense: true,
                    tileColor: docSnap['09:00 AM'] == false ? Colors.deepPurple.shade50 : Color.fromARGB(255, 244, 157, 151),
                    title: const Text('09:00 AM'),
                    ),
                ),
                  const SizedBox(width: 5.0,),
                  Expanded(
                    child: RadioListTile<DurationTime>(
                    value: DurationTime.DURATION2, 
                    groupValue: _durationTime, 
                    onChanged: (val) =>
                    docSnap['09:30 AM'] == false ?
                    {
                      setState(() {
                        _durationTime = val;
                        context.read<SummaryData>().assignAppointmentTime('09:30 AM');
                      }),
                    }
                    : {
                      _AlarmDialog(),
                    },
                    dense: true,
                    tileColor: docSnap['09:30 AM'] == false ? Colors.deepPurple.shade50 : Color.fromARGB(255, 244, 157, 151),
                    title: const Text('09:30 AM'),
                    ),
                  ),
                  const SizedBox(width: 5.0,),
                  Expanded(
                    child: RadioListTile<DurationTime>(
                    value: DurationTime.DURATION3, 
                    groupValue: _durationTime, 
                    onChanged: (val) =>
                    docSnap['10:00 AM'] == false ?
                    {
                      setState(() {
                        _durationTime = val;
                        context.read<SummaryData>().assignAppointmentTime('10:00 AM');
                      }),
                    }
                    : {
                      _AlarmDialog(),
                    },
                    dense: true,
                    tileColor: docSnap['10:00 AM'] == false ? Colors.deepPurple.shade50 : Color.fromARGB(255, 244, 157, 151),
                    title: const Text('10:00 AM'),
                    ),
                  ),
              ],
            ),
    
            Row(
              children: [
                Expanded(
                  child: RadioListTile<DurationTime>(
                    value: DurationTime.DURATION4, 
                    groupValue: _durationTime, 
                    onChanged: (val) =>
                    docSnap['10:30 AM'] == false ?
                    {
                      setState(() {
                        _durationTime = val;
                        context.read<SummaryData>().assignAppointmentTime('10:30 AM');
                      }),
                    }
                    : {
                      _AlarmDialog(),
                    },
                    dense: true,
                    tileColor: docSnap['10:30 AM'] == false ? Colors.deepPurple.shade50 : Color.fromARGB(255, 244, 157, 151),
                    title: const Text('10:30 AM'),
                    ),
                ),
                  const SizedBox(width: 5.0,),
                  Expanded(
                    child: RadioListTile<DurationTime>(
                    value: DurationTime.DURATION5, 
                    groupValue: _durationTime, 
                    onChanged: (val) =>
                    docSnap['11:00 AM'] == false ?
                    {
                      setState(() {
                        _durationTime = val;
                        context.read<SummaryData>().assignAppointmentTime('11:00 AM');
                      }),
                    }
                    : {
                      _AlarmDialog(),
                    },
                    dense: true,
                    tileColor: docSnap['11:00 AM'] == false ? Colors.deepPurple.shade50 : Color.fromARGB(255, 244, 157, 151),
                    title: const Text('11:00 AM'),
                    ),
                  ),
                  const SizedBox(width: 5.0,),
                  Expanded(
                    child: RadioListTile<DurationTime>(
                    value: DurationTime.DURATION6, 
                    groupValue: _durationTime, 
                    onChanged: (val) =>
                    docSnap['11:30 AM'] == false ?
                    {
                      setState(() {
                        _durationTime = val;
                        context.read<SummaryData>().assignAppointmentTime('11:30 AM');
                      }),
                    }
                    : {
                      _AlarmDialog(),
                    },
                    dense: true,
                    tileColor: docSnap['11:30 AM'] == false ? Colors.deepPurple.shade50 : Color.fromARGB(255, 244, 157, 151),
                    title: const Text('11:30 AM'),
                    ),
                  ),
              ],
            ),
    
            Row(
              children: [
                Expanded(
                  child: RadioListTile<DurationTime>(
                    value: DurationTime.DURATION7, 
                    groupValue: _durationTime, 
                    onChanged: (val) =>
                    docSnap['15:00 PM'] == false ?
                    {
                      setState(() {
                        _durationTime = val;
                        context.read<SummaryData>().assignAppointmentTime('15:00 PM');
                      }),
                    }
                    : {
                      _AlarmDialog(),
                    },
                    dense: true,
                    tileColor: docSnap['15:00 PM'] == false ? Colors.deepPurple.shade50 : Color.fromARGB(255, 244, 157, 151),
                    title: const Text('15:00 PM'),
                    ),
                ),
                  const SizedBox(width: 5.0,),
                  Expanded(
                    child: RadioListTile<DurationTime>(
                    value: DurationTime.DURATION8, 
                    groupValue: _durationTime, 
                    onChanged: (val) =>
                    docSnap['15:30 PM'] == false ?
                    {
                      setState(() {
                        _durationTime = val;
                        context.read<SummaryData>().assignAppointmentTime('15:30 PM');
                      }),
                    }
                    : {
                      _AlarmDialog(),
                    },
                    dense: true,
                    tileColor: docSnap['15:30 PM'] == false ? Colors.deepPurple.shade50 : Color.fromARGB(255, 244, 157, 151),
                    title: const Text('15:30 PM'),
                    ),
                  ),
                  const SizedBox(width: 5.0,),
                  Expanded(
                    child: RadioListTile<DurationTime>(
                    value: DurationTime.DURATION9, 
                    groupValue: _durationTime, 
                    onChanged: (val) =>
                    docSnap['16:00 PM'] == false ?
                    {
                      setState(() {
                        _durationTime = val;
                        context.read<SummaryData>().assignAppointmentTime('16:00 PM');
                      }),
                    }
                    : {
                      _AlarmDialog(),
                    },
                    dense: true,
                    tileColor: docSnap['16:00 PM'] == false ? Colors.deepPurple.shade50 : Color.fromARGB(255, 244, 157, 151),
                    title: const Text('16:00 PM'),
                    ),
                  ),
              ],
            ),
    
            Row(
              children: [
                Expanded(
                  child: RadioListTile<DurationTime>(
                    value: DurationTime.DURATION10, 
                    groupValue: _durationTime, 
                    onChanged: (val) =>
                    docSnap['16:30 PM'] == false ?
                    {
                      setState(() {
                        _durationTime = val;
                        context.read<SummaryData>().assignAppointmentTime('16:30 PM');
                      }),
                    }
                    : {
                      _AlarmDialog(),
                    },
                    dense: true,
                    tileColor: docSnap['16:30 PM'] == false ? Colors.deepPurple.shade50 : Color.fromARGB(255, 244, 157, 151),
                    title: const Text('16:30 PM'),
                    ),
                ),
                  const SizedBox(width: 5.0,),
                  Expanded(
                    child: RadioListTile<DurationTime>(
                    value: DurationTime.DURATION11, 
                    groupValue: _durationTime, 
                    onChanged: (val) =>
                    docSnap['17:00 PM'] == false ?
                    {
                      setState(() {
                        _durationTime = val;
                        context.read<SummaryData>().assignAppointmentTime('17:00 PM');
                      }),
                    }
                    : {
                      _AlarmDialog(),
                    },
                    dense: true,
                    tileColor: docSnap['17:00 PM'] == false ? Colors.deepPurple.shade50 : Color.fromARGB(255, 244, 157, 151),
                    title: const Text('17:00 PM'),
                    ),
                  ),
                  const SizedBox(width: 5.0,),
                  Expanded(
                    child: RadioListTile<DurationTime>(
                    value: DurationTime.DURATION12, 
                    groupValue: _durationTime, 
                    onChanged: (val) =>
                    docSnap['17:30 PM'] == false ?
                    {
                      setState(() {
                        _durationTime = val;
                        context.read<SummaryData>().assignAppointmentTime('17:30 PM');
                      }),
                    }
                    : {
                      _AlarmDialog(),
                    },
                    dense: true,
                    tileColor: docSnap['17:30 PM'] == false ? Colors.deepPurple.shade50 : Color.fromARGB(255, 244, 157, 151),
                    title: const Text('17:30 PM'),
                    ),
                  ),
              ],
            ),
    
          ],
        );
        }
        else if(snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(),);
        }
        else if(snapshot.hasError){
          _OffShiftDialog();
          return const SizedBox();
        }
        else{
          return const SizedBox();
        }
      }
    );
  }
}

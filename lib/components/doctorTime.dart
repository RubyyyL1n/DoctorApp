import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TimeSelection with ChangeNotifier {
  String? appointmentDate;
  Map<String, bool> duration = {
    '09:00 AM': false,
    '09:30 AM': false,
    '10:00 AM': false,
    '10:30 AM': false,
    '11:00 AM': false,
    '11:30 AM': false,
    '15:00 PM': false,
    '15:30 PM': false,
    '16:00 PM': false,
    '16:30 PM': false,
    '17:00 PM': false,
    '17:30 PM': false,
  };

  void update(String time) {
  
      FirebaseFirestore
      .instance
      .collection('Time')
      .doc(appointmentDate)
      .update(
        {
          time: true,
        }
      );

    // else{
    //   print("The duration is been selected");
    //   return false;
    // }
  }

  void initiateDate (String selDate) {
    appointmentDate = selDate;
    createWorkShift();
  }

  // ignore: non_constant_identifier_names
  Map<String, dynamic> ToFirestore() => {
    '09:00 AM': duration['09:00 AM'],
    '09:30 AM': duration['09:30 AM'],
    '10:00 AM': duration['10:00 AM'],
    '10:30 AM': duration['10:30 AM'],
    '11:00 AM': duration['11:00 AM'],
    '11:30 AM': duration['11:30 AM'],
    '15:00 PM': duration['15:00 PM'],
    '15:30 PM': duration['15:30 PM'],
    '16:00 PM': duration['16:00 PM'],
    '16:30 PM': duration['16:30 PM'],
    '17:00 PM': duration['17:00 PM'],
    '17:30 PM': duration['17:30 PM'],
    'appointmentDate': appointmentDate,
  };

  Future createWorkShift() async {

    final docUser = FirebaseFirestore.instance.collection('Time').doc(appointmentDate);
    docUser.set(ToFirestore());
    
  }
  
}
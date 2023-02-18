import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';


class MyNotification with ChangeNotifier{
  String? title;
  String? content;
  String? notificationID;
  String? currentTime;
  String? userEmail;

  void ApproveNotification(String doctorName, String date, String duration) {
    title = 'Schedule Success';
    content = 'You have successfully booked an appointment with $doctorName, on $date, $duration. Please be on time';
  }

  void ChangeNotification(String doctorName, String date, String duration) {
    title = 'Schedule Changed';
    content = 'You have successfully change an appointment with $doctorName, on $date, $duration. Please be on time';
  }

  void CancelNotification(String doctorName, String date, String duration) {
    title = 'Schedule Cancelled';
    content = 'You have successfully cancelled an appointment with $doctorName, on $date, $duration. Your can see the cancel appointment in "My Appointment" ';
  }

  void setEmail(String userEmail) {
    this.userEmail = userEmail;
    currentTime = formatDate(DateTime.now(), [M,' ',dd, ',',yyyy]);
  }

  Map<String, dynamic> ToFirestore() => {
    'title': title,
    'content': content,
    'notificationID': notificationID,
    'userEmail': userEmail,
    'currentTime': currentTime,
  };

  Future createNotification() async {

    final docUser = FirebaseFirestore.instance.collection('Notifications').doc();
    notificationID = docUser.id;
    docUser.set(this.ToFirestore());
    
  }

}
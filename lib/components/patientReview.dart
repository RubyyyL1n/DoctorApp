import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Review with ChangeNotifier{
  String? doctorName;
  String? patientName;
  String? appointmentID;
  double? patientStars;
  String? patientReview;
  String? reviewID;
  String? appointmentStatus;
  String? patientOption;

  void setDoctor(String doctorName, String appointmentID, String patientName, String appointmentStatus) {
    this.doctorName = doctorName;
    this.patientName = patientName;
    this.appointmentID = appointmentID;
    this.appointmentStatus = appointmentStatus;
  }

  void setReview(String patientReview, double patientStars) {
    this.patientReview = patientReview;
    this.patientStars = patientStars;
  }


  void setPatientOption(String patientOption) {
    this.patientOption = patientOption;
  }


   Map<String, dynamic> ToFirestore() => {
    "doctorName": doctorName,
    "patientName": patientName,
    "patientStars": patientStars,
    "patientReview": patientReview,
    "appointmentID": appointmentID,
    "appointmentStatus": appointmentStatus,
    "reviewID": reviewID,
    "patientOption": patientOption,
  };

  Future createReviews() async {

    final docUser = FirebaseFirestore.instance.collection('Reviews').doc();
     reviewID = docUser.id;
    docUser.set(this.ToFirestore());
    
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';



class SummaryData with ChangeNotifier{
  
  String? patientName;
  String? patientGender;
  String? patientEmail;
  String? patientProblem;
  String? doctorName;
  String? doctorSpecialty;
  String? doctorHospital;
  String? doctorImage;
  String? appointmentDate;
  String? appointmentTime;
  String? appointmentId;
  String appointmentStatus = 'Under process';

  void assignPatient(String patientName, String patientEmail, String patientGender, String patientProblem) {
    this.patientName = patientName;
    this.patientGender = patientGender;
    this.patientEmail = patientEmail;
    this.patientProblem = patientProblem;
  }

  void assignAppointmentDate(String appointmentDate) {
    this.appointmentDate = appointmentDate;
  }
  
  void assignAppointmentTime(String appointmentTime) {
    this.appointmentTime = appointmentTime;
  }

  void assignDoctor(String doctorName, String doctorSpecialty, String doctorHospital, String doctorImage) {
    this.doctorName = doctorName;
    this.doctorSpecialty = doctorSpecialty;
    this.doctorHospital = doctorHospital;
    this.doctorImage = doctorImage;
  }

  Map<String, dynamic> ToFirestore() => {
    'patientName': patientName,
    'patientGender': patientGender,
    'patientEmail': patientEmail,
    'patientProblem': patientProblem,
    'appointmentDate': appointmentDate,
    'appointmentTime': appointmentTime,
    'doctorName': doctorName,
    'doctorSpecialty': doctorSpecialty,
    'doctorHospital': doctorHospital,
    'appointmentID': appointmentId,
    'doctorImage': doctorImage,
    'appointmentStatus': appointmentStatus,
  };

  Future createAppointment() async {

    final docUser = FirebaseFirestore.instance.collection('Appointments').doc();
    appointmentId = docUser.id;
    docUser.set(this.ToFirestore());
    
  }
}
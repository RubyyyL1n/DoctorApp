import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class Favorite with ChangeNotifier{
  String? doctorName;
  String? doctorSpecialty;
  double? doctorRating;
  String? doctorHospital;
  String? userEmail;
  String? favoriteDoctorId;
  String? doctorPicture;
  String? doctorNumberOfPatient;
  String? doctorDescription;
  bool? doctorIsOpen;
  String? doctorYearOfExperience;

//和数据库里的数据进行一一对应
  Map<String, dynamic> ToFirestore() => {
    "doctorName": doctorName,
    "doctorSpecialty": doctorSpecialty,
    "doctorRating": doctorRating,
    "doctorHospital": doctorHospital,
    "favoriteDoctorId": favoriteDoctorId,
    "userEmail": userEmail,
    "doctorPicture": doctorPicture,
    "doctorNumberOfPatient": doctorNumberOfPatient,
    "doctorDescription": doctorDescription,
    "doctorIsOpen":doctorIsOpen,
    "doctorYearOfExperience":doctorYearOfExperience,

  };
//相当于set函数
  void setInfo(String doctorName, String doctorSpecialty, double doctorRating, String doctorHospital, String? userEmail, String? doctorPicture, String? doctorNumberOfPatient,String? doctorDescription,bool? doctorIsOpen,String? doctorYearOfExperience) {
    this.doctorName = doctorName;
    this.doctorSpecialty = doctorSpecialty;
    this.doctorRating = doctorRating;
    this.doctorHospital = doctorHospital;
    this.userEmail = userEmail;
    this.doctorPicture = doctorPicture;
    this.doctorNumberOfPatient = doctorNumberOfPatient;
    this.doctorDescription=doctorDescription;
    this.doctorIsOpen=doctorIsOpen;
    this.doctorYearOfExperience=doctorYearOfExperience;
  }

  Future createFavorite() async {
    final docUser = FirebaseFirestore.instance.collection("Favorite").doc();
    favoriteDoctorId = docUser.id;
    docUser.set(this.ToFirestore());
  }
}
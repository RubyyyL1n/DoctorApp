import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorSpecialty {
  String? doctorName;
  String? doctorSpecialty;
  double? doctorRating;
  String? doctorHospital;
  String? doctorNumberOfPatient;
  String? doctorYearOfExperience;
  String? doctorDescription;
  String? doctorPicture;
  bool? doctorIsOpen;

  DoctorSpecialty(
    this.doctorName,
    this.doctorSpecialty,
    this.doctorRating,
    this.doctorHospital,
    this.doctorNumberOfPatient,
    this.doctorYearOfExperience,
    this.doctorDescription,
    this.doctorPicture,
    this.doctorIsOpen,
  );

  DoctorSpecialty.fromDocumentSnapshot(QueryDocumentSnapshot snapshot) {
    doctorName = snapshot.get('doctorName');
    doctorSpecialty = snapshot.get('doctorSpecialty');
    doctorRating = snapshot.get('doctorRating');
    doctorHospital = snapshot.get('doctorHospital');
    doctorNumberOfPatient = snapshot.get('doctorNumberOfPatient');
    doctorYearOfExperience = snapshot.get('doctorYearOfExperience');
    doctorDescription = snapshot.get('doctorDescription');
    doctorPicture = snapshot.get('doctorPicture');
    doctorIsOpen = snapshot.get('doctorIsOpen');
  }
}
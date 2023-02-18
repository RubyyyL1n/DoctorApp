import 'package:cloud_firestore/cloud_firestore.dart';
import 'doctor.dart';

class Doctor{
  Doctor(
      {this.doctorName = '',
      this.doctorSpecialty = '',
      this.doctorRating = 0.0,
      this.doctorHospital = '',
      this.doctorNumberOfPatient = '',
      this.doctorYearOfExperience = '',
      this.doctorDescription = '',
      this.doctorPicture = '',
      this.doctorIsOpen = false,
      this.isBeenSelect = false});

  String doctorName;
  String doctorSpecialty;
  double doctorRating;
  String doctorHospital;
  String doctorNumberOfPatient;
  String doctorYearOfExperience;
  String doctorDescription;
  String doctorPicture;
  bool doctorIsOpen;
  bool isBeenSelect;

  
  Map<String, dynamic> ToFirestore() => {
    'doctorName': doctorName,
    'doctorSpecialty': doctorSpecialty,
    'doctorRating': doctorRating,
    'doctorHospital': doctorHospital,
    'doctorNumberOfPatient': doctorNumberOfPatient,
    'doctorYearOfExperience': doctorYearOfExperience,
    'doctorDescription': doctorDescription,
    'doctorPicture': doctorPicture,
    'doctorIsOpen': doctorIsOpen,
  };

  factory Doctor.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options){
    final data = snapshot.data();
    
    return Doctor(
    doctorName: data?['doctorName'],
    doctorDescription: data?['doctorDescription'],
    doctorHospital: data?['doctorHospital'],
    doctorIsOpen: data?['doctorIsOpen'],
    doctorNumberOfPatient: data?['doctorNumberOfPatient'],
    doctorPicture: data?['doctorPicture'],
    doctorYearOfExperience: data?['doctorYearOfExperience'],
    doctorRating: data?['doctorRating'],
    doctorSpecialty: data?['doctorSpecialty'],

    );
}
    setter(Doctor temp) => {
    doctorName = temp.doctorName,
    doctorDescription = temp.doctorDescription,
    doctorHospital = temp.doctorHospital,
    doctorIsOpen = temp.doctorIsOpen,
    doctorNumberOfPatient = temp.doctorNumberOfPatient,
    doctorPicture = temp.doctorPicture,
    doctorRating = temp.doctorRating,
    doctorSpecialty = temp.doctorSpecialty,
    doctorYearOfExperience = temp.doctorYearOfExperience,
  
  };
}


Future createDoctor({required int index, required Doctor doctor}) async {
  final docUser = FirebaseFirestore.instance.collection('Doctors').doc('Doctor_$index');
  docUser.set(doctor.ToFirestore());

  }

//Generate doctor database
  // ignore: non_constant_identifier_names
  void GenerateDoctorDatabase() {
  for(var i = 0; i < topDoctors.length; i++) {
    createDoctor(index: i+1, doctor: topDoctors[i]);
  }
}

//Read doctor database
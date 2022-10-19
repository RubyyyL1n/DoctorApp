import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sqq_flutter2/components/top_doctor_card.dart';
import 'package:sqq_flutter2/model/doctor.dart';
import 'package:sqq_flutter2/model/doctors.dart';

class TopDoctorList extends StatelessWidget {
  const TopDoctorList({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: topDoctors.length,
      itemBuilder: (context, index) {
        Doctor doc = Doctor();
        _readDoctor(index+1, doc);
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed('doctor_details', arguments: Doctor(
              doctorName: doc.doctorName,
              doctorDescription: doc.doctorDescription,
              doctorHospital: doc.doctorHospital,
              doctorIsOpen: doc.doctorIsOpen,
              doctorNumberOfPatient: doc.doctorNumberOfPatient,
              doctorPicture: doc.doctorPicture,
              doctorRating: doc.doctorRating,
              doctorSpecialty: doc.doctorSpecialty,
              doctorYearOfExperience: doc.doctorYearOfExperience,
            ));
          },
          
          child: TopDoctorsCard(
            doctor: topDoctors[index],
          ),
        );
      },
    );
  }
}

//Read data from database
 void _readDoctor(var index, Doctor doc) async{
  final ref = FirebaseFirestore.instance.collection('Doctors').doc('Doctor_$index').withConverter(
    fromFirestore: Doctor.fromFirestore, toFirestore: (Doctor doctor, Null) => doctor.ToFirestore(),);
    final docSnap = await ref.get();
    final temp = docSnap.data();
    if (temp != null){
      doc.setter(temp);
    }
    else {
      print("No such document");
    }
}
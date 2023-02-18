import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sqq_flutter2/components/top_doctor_card.dart';
import 'package:sqq_flutter2/model/doctor.dart';
import 'package:sqq_flutter2/model/doctors.dart';

class TopDoctorList extends StatelessWidget {
  const TopDoctorList({super.key});
  @override
  Widget build(BuildContext context) {
    final ref = FirebaseFirestore.instance.collection('Doctors');
    return StreamBuilder<QuerySnapshot>(
        stream: ref.snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            final snap = snapshot.data!.docs;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snap.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('doctor_details', arguments: Doctor(
                      doctorName: snap[index]['doctorName'],
                      doctorDescription: snap[index]['doctorDescription'],
                      doctorHospital: snap[index]['doctorHospital'],
                      doctorIsOpen: snap[index]['doctorIsOpen'],
                      doctorNumberOfPatient: snap[index]['doctorNumberOfPatient'],
                      doctorPicture: snap[index]['doctorPicture'],
                      doctorRating: snap[index]['doctorRating'],
                      doctorSpecialty: snap[index]['doctorSpecialty'],
                      doctorYearOfExperience: snap[index]['doctorYearOfExperience'],
                    ));
                  },

                  child: TopDoctorsCard(
                    snap: snap,
                    index: index,
                  ),
                );
              },
            );
          }
          else if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
          }
          else {
            return const SizedBox();
          }
        }
    );
  }
}
// ignore_for_file: constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqq_flutter2/constants.dart';
import 'package:sqq_flutter2/model/doctor_specialty.dart';


// ignore: camel_case_types
enum doctorSpecialty {ALL, Heart, Consultation, Dental, Eye, Child, Skin}

class ViewAll extends StatelessWidget {
  ViewAll({super.key});

  final FirestoreController firestoreController = Get.put(FirestoreController());
  final ChipController chipController = Get.put(ChipController());
  final List<String> _chipLabel = ['All', 'Heart', 'Consultation', 'Dental', 'Eye', 'Child', 'Skin'];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(onPressed: () {
                    Navigator.pop(context);
                  }, 
                  icon: const Icon(Icons.arrow_back, color: kBlackColor900,)),
                ],
              ),

              Obx(
                (() => Wrap(
                  spacing: 20,
                  children: [
                    for(var i = 0; i < 7; i++) 
                    ChoiceChip(
                        label: Text(_chipLabel[i]), 
                        selected: chipController.selectedChip == i,
                        onSelected: (bool selected) {
                          chipController.selectedChip = selected ? i : null;
                          firestoreController.onInit();
                          firestoreController.getDoctor(
                            doctorSpecialty.values[chipController.selectedChip]
                          );
                        },),
                  ]
                    )
                )
              ),
              Obx(() => Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: firestoreController._doctorList.length,
                  itemBuilder: ((context, index) {
                    return Card(
                      child: ListTile(
                        leading:  Image(image: AssetImage('asset/images/${firestoreController._doctorList[index].doctorPicture}')),
                        title: Text("${firestoreController._doctorList[index].doctorName}"),
                        subtitle: Text("${firestoreController._doctorList[index].doctorHospital}"),
                        ),
                    );
                  }))))
            ],
          ),
        )
        ),
    );
  }
}


class FirestoreController extends GetxController {
  final CollectionReference _doctor = FirebaseFirestore.instance.collection('Doctors');
  final _doctorList = <DoctorSpecialty>[].obs;
  // ignore: prefer_final_fields
  ChipController _chipController = Get.put(ChipController());

  @override
  void onInit() {
    _doctorList.bindStream(
      getDoctor(doctorSpecialty.values[_chipController.selectedChip]));
      super.onInit();
  }

  Stream<List<DoctorSpecialty>> getDoctor(doctorSpecialty specialty) {
    switch(specialty) {
      case doctorSpecialty.ALL:
        Stream<QuerySnapshot> stream = _doctor.snapshots();
        return stream.map((snapshot) => snapshot.docs.map((snap) {
          return DoctorSpecialty.fromDocumentSnapshot(snap);
        }).toList());

        case doctorSpecialty.Heart:
        Stream<QuerySnapshot> stream = _doctor.where('doctorSpecialty', isEqualTo: 'Heart').snapshots();
        return stream.map((snapshot) => snapshot.docs.map((snap) {
          return DoctorSpecialty.fromDocumentSnapshot(snap);
        }).toList());

        case doctorSpecialty.Child:
        Stream<QuerySnapshot> stream = _doctor.where('doctorSpecialty', isEqualTo: 'Child').snapshots();
        return stream.map((snapshot) => snapshot.docs.map((snap) {
          return DoctorSpecialty.fromDocumentSnapshot(snap);
        }).toList());

        case doctorSpecialty.Dental:
        Stream<QuerySnapshot> stream = _doctor.where('doctorSpecialty', isEqualTo: 'Dental').snapshots();
        return stream.map((snapshot) => snapshot.docs.map((snap) {
          return DoctorSpecialty.fromDocumentSnapshot(snap);
        }).toList());

        case doctorSpecialty.Consultation:
        Stream<QuerySnapshot> stream = _doctor.where('doctorSpecialty', isEqualTo: 'Consultation').snapshots();
        return stream.map((snapshot) => snapshot.docs.map((snap) {
          return DoctorSpecialty.fromDocumentSnapshot(snap);
        }).toList());

        case doctorSpecialty.Skin:
        Stream<QuerySnapshot> stream = _doctor.where('doctorSpecialty', isEqualTo: 'Skin').snapshots();
        return stream.map((snapshot) => snapshot.docs.map((snap) {
          return DoctorSpecialty.fromDocumentSnapshot(snap);
        }).toList());

        case doctorSpecialty.Eye:
        Stream<QuerySnapshot> stream = _doctor.where('doctorSpecialty', isEqualTo: 'Eye').snapshots();
        return stream.map((snapshot) => snapshot.docs.map((snap) {
          return DoctorSpecialty.fromDocumentSnapshot(snap);
        }).toList());
    }
  }
}

class ChipController extends GetxController {
  final _selectedChip = 0.obs;
  get selectedChip => _selectedChip.value;
  set selectedChip(index) => _selectedChip.value = index;
}


import 'dart:io';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqq_flutter2/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqq_flutter2/model/set_profile.dart';



class DoctorProfileRegisterPage extends StatefulWidget {
  const DoctorProfileRegisterPage({super.key});

  @override
  State<DoctorProfileRegisterPage> createState() => _DoctorProfileRegisterPageState();
}

class _DoctorProfileRegisterPageState extends State<DoctorProfileRegisterPage> {
  XFile? _imageFile;
  final ref = FirebaseFirestore.instance.collection('Doctors').doc('Doctor_1');
  final ImagePicker _picker = ImagePicker();
  final doctorNameController = TextEditingController();
  final doctorHospitalController = TextEditingController();
  final doctorSpecialtyController = TextEditingController();
  final doctorDescriptionController = TextEditingController();
  //final doctorIsOpenController = TextEditingController();
  final scrollController = ScrollController();
  late bool isOpen;
  Profile? userDoc;
  //Profile? profile;
  String userImageUrl = '';

  void _ProfileUpdated() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Profile successfully update!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: kGreenColor),),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).popAndPushNamed('admin');
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                color: kGreenColor,
                child: const Text('Ok', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: kWhiteColor)),
              ),
            ],
          );
        }
    );
  }


  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if(scrollController.position.maxScrollExtent == scrollController.offset) {}
    });
    ref.get().then((value) => isOpen = value.data()!['doctorIsOpen']);
  }

  @override
  void dispose(){
    doctorNameController.dispose();
    doctorHospitalController.dispose();
    doctorSpecialtyController.dispose();
    doctorDescriptionController.dispose();
    //doctorIsOpenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: ref.snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            userImageUrl = snapshot.data!['doctorPicture'];
            //isOpen = snapshot.data!['doctorIsOpen'];
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                child: ListView(
                  controller: scrollController,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(left: 16, top: 25, right: 16),
                  children: [
                    // SizedBox(height: 15,),
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 80,
                            backgroundImage: AssetImage('asset/images/${snapshot.data?['doctorPicture']}'),
                          ),
                          Positioned(
                              bottom: 0,
                              right: 0,
                              child: InkWell(
                                onTap: () {
                                  showModalBottomSheet(context: context, builder: ((builder) => BottomSheet()));
                                },
                                child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: kBlueColor,
                                    ),
                                    child: Icon(Icons.edit, color: kWhiteColor,)),
                              )
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 35,),
                    TextField(
                      controller: doctorNameController,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(bottom: 3),
                          labelText: 'Full Name',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          // ignore: unnecessary_null_comparison
                          hintText: snapshot.data?["doctorName"] ?? 'user name',
                          hintStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: kGreyColor800,
                          )
                      ),
                    ),
                    const SizedBox(height: 20,),
                    TextField(
                      controller: doctorHospitalController,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(bottom: 3),
                          labelText: 'doctorHospital',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: snapshot.data?["doctorHospital"] ?? 'User Nick Name',
                          hintStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: kGreyColor800,
                          )
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Expanded(
                      child: TextFormField(
                        maxLines: 10,
                        controller: doctorDescriptionController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(bottom: 3),
                          labelText: 'Doctor Description...',
                          hintText: snapshot.data?["doctorDescription"] ?? 'Doctor Description...',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    TextFormField(
                      controller: doctorSpecialtyController,
                      enabled: false,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(bottom: 3),
                          labelText: 'Doctor Specialty',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: snapshot.data?["doctorSpecialty"] ?? 'Doctor Specialty',
                          hintStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: kGreyColor800,
                          )
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (email) => email != null && !EmailValidator.validate(email) ? 'Enter a valid email' : null,
                    ),
                    const SizedBox(height: 20,),
                    // TextFormField(
                    //   controller: doctorIsOpenController,
                    //     decoration: InputDecoration(
                    //       contentPadding: const EdgeInsets.only(bottom: 3),
                    //       labelText: 'Open',
                    //       floatingLabelBehavior: FloatingLabelBehavior.always,
                    //       hintText: snapshot.data?["doctorIsOpen"].toString() ?? 'true/false',
                    //       hintStyle: TextStyle(
                    //         inherit: false,
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.bold,
                    //         color: kGreyColor800,
                    //       )
                    //     ),
                    //     autovalidateMode: AutovalidateMode.onUserInteraction,
                    //     validator: (value) => value != 'true' && value != 'false' ? 'Enter true or false': null,
                    //   ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Switch(
                            value: isOpen,
                            activeColor: kGreenColor,
                            onChanged: (value){
                              setState(() {
                                isOpen = value;
                              });
                            }),
                      ],
                    ),
                    const SizedBox(height: 35,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 50) ,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child:Text(
                              'Cancel',
                              style: TextStyle(fontSize: 14, letterSpacing: 2.2, color: kBlackColor900),)),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                            onPressed: () {
                              AddProfile(
                                doctorNameController.text.isEmpty ? snapshot.data!['doctorName'] : doctorNameController.text,
                                doctorHospitalController.text.isEmpty ? snapshot.data!['doctorHospital'] : doctorHospitalController.text,
                                doctorSpecialtyController.text.isEmpty ? snapshot.data!['doctorSpecialty'] : doctorSpecialtyController.text,
                                doctorDescriptionController.text.isEmpty ? snapshot.data!['doctorDescription'] : doctorDescriptionController.text,
                                //doctorIsOpenController.text.isEmpty ? snapshot.data!['doctorIsOpen'] : !snapshot.data!['doctorIsOpen'],
                                isOpen,
                                userImageUrl.isEmpty ? snapshot.data!['doctorPicture'] : userImageUrl,
                              );
                              _ProfileUpdated();

                            },
                            child: Text(
                              'SAVE',
                              style: TextStyle(fontSize: 14, letterSpacing: 2.2, color: kWhiteColor),))
                      ],
                    )
                  ],
                ),
              ),
            );
          }
          else if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
          }
          return const SizedBox();
        }
    );
  }

// Widget BuildTextField(String labelText, TextEditingController controller) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 3),
//       child: TextField(
//                 controller: controller,
//                 decoration: InputDecoration(
//                   contentPadding: EdgeInsets.only(bottom: 10),
//                   labelText: labelText,
//                   floatingLabelBehavior: FloatingLabelBehavior.always,
//                 ),
//               )

//     );
//   }

  Widget BottomSheet() {
    return Container(
      height: 150.0,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Text(
            'Choose Profile Image',
            style: TextStyle(
              fontSize: 20.0,

            ),),
          SizedBox(height: 20,),
          Column(children: <Widget>[
            ElevatedButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              label: Text('Camera'),
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: Text('Gallery'),
            ),
          ],)
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final XFile = await _picker.pickImage(
      source: source,
      maxHeight: 532,
      maxWidth: 532,
      imageQuality: 75,
    );
    if(XFile != null){

      setState(() {
        _imageFile = XFile;
        userImageUrl = XFile.path.toString();
      });
    }else{
      userImageUrl = "https://img1.baidu.com/it/u=592570905,1313515675&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500";
    }

  }


  Future AddProfile(String doctorName, String doctorHospital, String doctorSpecialty, String doctorDescription, bool doctorIsOpen, String doctorPicture) async {
    await FirebaseFirestore.instance.collection('Doctors').doc('Doctor_1').update({
      'doctorName': doctorName,
      'doctorSpecialty': doctorSpecialty,
      'doctorHospital': doctorHospital,
      'doctorDescription': doctorDescription,
      'doctorIsOpen': doctorIsOpen,
      'doctorPicture': doctorPicture,
    });
  }


}

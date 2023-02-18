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



class ProfileRegisterPage extends StatefulWidget {
  const ProfileRegisterPage({super.key});

  @override
  State<ProfileRegisterPage> createState() => _ProfileRegisterPageState();
}

class _ProfileRegisterPageState extends State<ProfileRegisterPage> {
  XFile? _imageFile;
  final ref = FirebaseFirestore.instance.collection('Profiles').doc('${FirebaseAuth.instance.currentUser?.email}');
  final ImagePicker _picker = ImagePicker();
  final userFullNameController = TextEditingController();
  final userNickNameController = TextEditingController();
  final userDoBController = TextEditingController();
  final userEmailController = TextEditingController();
  final userGenderController = TextEditingController();
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
              Navigator.of(context).popAndPushNamed('settings');
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
  }

  @override
  void dispose(){
    userFullNameController.dispose();
    userNickNameController.dispose();
    userDoBController.dispose();
    userEmailController.dispose();
    userGenderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: kBlackColor900,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Fill Your Profile', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color: kBlackColor900),),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: ref.snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
          //userImageUrl = snapshot.data!['userImage'];
          return Container(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: ListView(
                padding: EdgeInsets.only(left: 16, top: 25, right: 16),
                children: [
                 // SizedBox(height: 15,),
                  Center(
                    child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 80,
                        // ignore: unrelated_type_equality_checks
                        backgroundImage: userImageUrl.isEmpty || userImageUrl == 'https://img1.baidu.com/it/u=592570905,1313515675&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500'
                                        ? const NetworkImage('https://img1.baidu.com/it/u=592570905,1313515675&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500') as ImageProvider
                                        : FileImage(File(userImageUrl)),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(context: context, builder: ((builder) => BottomSheet()));
                            print(userImageUrl);
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
                  SizedBox(height: 35,),
                  TextField(
                      controller: userFullNameController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 3),
                        labelText: 'Full Name',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        // ignore: unnecessary_null_comparison
                        hintText: snapshot.data?["userName"] == null ? 'user name' : snapshot.data?["userName"],
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: kGreyColor800,
                        )
                      ),
                    ),
                  SizedBox(height: 20,),
                  TextField(
                    controller: userNickNameController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 3),
                        labelText: 'NickName',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: snapshot.data?["userNickName"] == null ? 'User Nick Name' : snapshot.data?["userNickName"],
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: kGreyColor800,
                        )
                      ),
                    ),
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: userDoBController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 3),
                        labelText: 'Date of Birth',
                        hintText: snapshot.data?["userDOB"] ?? 'User Date of Birth',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: const Icon(Icons.calendar_today_rounded, size: 16,),
                      ),
                      onTap: () async {
                        DateTime? pickeddate = await showDatePicker(
                          context: context, 
                          initialDate: DateTime.now(),
                           firstDate: DateTime(1960), 
                           lastDate: DateTime(2101));
                           if(pickeddate != null) {
                            setState(() {
                              userDoBController.text = DateFormat('yyyy-MM-dd').format(pickeddate);
                            });
                           }
                      },
                    ),
                    SizedBox(height: 20,),
                  TextFormField(
                    controller: userEmailController,
                    enabled: false,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 3),
                        labelText: 'Email',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: snapshot.data?["userEmail"] == null ? 'user@user.com' : snapshot.data?["userEmail"],
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: kGreyColor800,
                        )
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (email) => email != null && !EmailValidator.validate(email) ? 'Enter a valid email' : null,
                    ),
                    SizedBox(height: 20,),
                  TextFormField(
                    controller: userGenderController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 3),
                        labelText: 'Gender',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: snapshot.data?["userGender"] == null ? 'M/F': snapshot.data?["userGender"],
                        hintStyle: TextStyle(
                          inherit: false,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: kGreyColor800,
                        )
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => value != 'M' && value != 'F' ? 'Enter M or F': null,
                    ),
                  SizedBox(height: 35,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 50) ,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
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
                            userFullNameController.text.isEmpty ? snapshot.data!['userName'] : userFullNameController.text,
                            userNickNameController.text.isEmpty ? snapshot.data!['userNickName'] : userNickNameController.text,
                            userDoBController.text.isEmpty ? snapshot.data!['userDOB'] : userDoBController.text,
                            userEmailController.text.isEmpty ? snapshot.data!['userEmail'] : userEmailController.text,
                            userGenderController.text.isEmpty ? snapshot.data!['userGender'] : userGenderController.text,
                            userImageUrl.isEmpty ? snapshot.data!['userImage'] : userImageUrl,
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
            return Center(child: CircularProgressIndicator(),);
          }
          return SizedBox();
        }
      ),


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
  // ignore: non_constant_identifier_names
  final XFile = await _picker.pickImage(
    source: source,
    maxHeight: 532,
    maxWidth: 532,
    imageQuality: 75,
    );
if(XFile != null){

setState(() {
  _imageFile = XFile;
  userImageUrl = XFile.path;
});
  }else{
    userImageUrl = "https://img1.baidu.com/it/u=592570905,1313515675&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500";
  }

}


Future AddProfile(String userName, String userNickName, String userDOB, String userEmail, String userGender, String userImage) async {
  if(userImage == ''){
    userImage = "https://img1.baidu.com/it/u=592570905,1313515675&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500";
  };
  await FirebaseFirestore.instance.collection('Profiles').doc(FirebaseAuth.instance.currentUser?.email).update({
    'userName': userName,
    'userNickName': userNickName,
    'userDOB': userDOB,
    'userEmail': userEmail,
    'userGender': userGender,
    'userImage': userImage,
  });
}


  }


  
// ignore: file_names
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sqq_flutter2/components/security.dart';
import 'package:sqq_flutter2/constants.dart';
import 'package:sqq_flutter2/model/Favorite_doctor.dart';
import 'package:sqq_flutter2/model/myAppointment.dart';
import 'package:sqq_flutter2/model/noti.dart';

import 'help_center.dart';

class GetUserInformation extends StatefulWidget {
  const GetUserInformation({super.key});

  @override
  State<GetUserInformation> createState() => _GetUserInformationState();
}

class _GetUserInformationState extends State<GetUserInformation> {
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Profiles');

  String? userName;
  String? userEmail;
  String? userImageUrl;
  String? userNickName;
  String? userDOB;
  String? userGender;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot> (
      future: users.doc('${user?.email}').get(),
      builder: ((context, snapshot) {
        if(snapshot.hasError) {
          return const Text("Something is wrong");
        }
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        Map<String, dynamic> data = snapshot.data?.data() as Map<String, dynamic>;    
        userName = data['userName'].length == 0 ? 'User': data['userName'];
        userEmail = data['userEmail'];
        userImageUrl = data['userImage'];
        userDOB = data['userDOB'];
        userGender = data['userGender'];
        userNickName = data['userNickName'];

        return ListView(
        
        padding: const EdgeInsets.only(left: 18, right: 20, top: 40),
        children: [
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 105,
                width: 105,
                child: CircleAvatar(
                  backgroundColor: kBlackColor800,
                  backgroundImage: userImageUrl!.isEmpty || userImageUrl == 'https://img1.baidu.com/it/u=592570905,1313515675&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500'
                   ? const NetworkImage('https://img1.baidu.com/it/u=592570905,1313515675&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500') as ImageProvider
                   : FileImage(File(userImageUrl!)),
                ),
                ),
                const SizedBox(width: 10,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 200,
                      child:Text(
                      '$userName',
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 24),
                    ),
                    ),
                    Container(
                      width: 200,
                      child: Text(
                        '$userEmail',
                        style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 14),
                      ),
                    )
                  ],
                ),
            ],
          ),
          const SizedBox(height: 32,),
          Center(
            child: Container(
              height: 48,
              width: 150,
              decoration: BoxDecoration(
                color: kBlackColor800,
                borderRadius: BorderRadius.circular(40),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('profile');
                },
                child:Center(
                child: Text(
                'Edit Profile',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 20, fontWeight: FontWeight.w200, color: kWhiteColor),
                textAlign: TextAlign.center,
              ),
              ),
              ),
            ),
          ),
          const SizedBox(height: 20,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.notifications),
                        const SizedBox(width: 20,),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: ((context) => UserNotification())));
                          }, 
                          child: Row(
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              const Text('Notification',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(width: 160,),
                              const Icon(Icons.arrow_right, size: 30,),
                            ],
                            )
                          ),
                      ],
                    ),
                    const SizedBox(height: 20,),
                        Row(
                          children: [
                            const Icon(Icons.book_online),
                            const SizedBox(width: 20,),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: ((context) => const MyAppointment())));
                          }, 
                          child: Row(
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              const Text('My Appointments',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(width: 107,),
                              const Icon(Icons.arrow_right, size: 30,),
                            ],
                            )
                          ),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          children: [
                            const Icon(Icons.turned_in),
                            const SizedBox(width: 20,),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: ((context) => FavoriteDoctor())));
                          }, 
                          child: Row(
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              const Text('Favorite Doctors',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(width: 116,),
                              const Icon(Icons.arrow_right, size: 30,),
                            ],
                            )
                          ),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          children: [
                            const Icon(Icons.security),
                            const SizedBox(width: 20,),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: ((context) => security())));
                          },
                          child: Row(
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              const Text('Security',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(width: 192,),
                              const Icon(Icons.arrow_right, size: 30,),
                            ],
                            )
                          ),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          children: [
                            const Icon(Icons.help_center),
                            const SizedBox(width: 20,),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: ((context) => helpCenter())));
                          },
                          child: Row(
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              const Text('Help Center',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(width: 158,),
                              const Icon(Icons.arrow_right, size: 30,),
                            ],
                            )
                          ),
                          ],
                        ),
                        
                  ],
                ),
              )
            ],),
          const SizedBox(height: 32,),
          Container(
            height: 50,
            width: 400,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: kRedColor),
            child: GestureDetector(
              onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).popAndPushNamed('signin');
              },
              child:const Center(
              child:Text(
              'Sign Out',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w200, color: kWhiteColor),
            ),
            ),
          ),
          ),
        ]);
   }
    ),
        );
      }
  }

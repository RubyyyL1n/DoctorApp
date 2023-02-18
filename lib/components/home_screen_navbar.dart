import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:sqq_flutter2/constants.dart';
import 'package:sqq_flutter2/model/admin_home_page.dart';

class HomeScreenNavbar extends StatefulWidget {
  const HomeScreenNavbar({super.key});

  @override
  State<HomeScreenNavbar> createState() => _HomeScreenNavbarState();
}

class _HomeScreenNavbarState extends State<HomeScreenNavbar> {
  final ref = FirebaseFirestore.instance.collection('Profiles').doc(FirebaseAuth.instance.currentUser!.email);
  String userImage = '';

  @override
  void initState() {
    // TODO: implement initState
    
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
 
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: ref.snapshots(),
      builder: (context, snapshot) {
        if(snapshot.hasData)
        {
        userImage = snapshot.data!['userImage'];
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: ((context) => AdminHomePage())));
              },
              child: Container(
                height: 24,
                width: 24,
                decoration: const BoxDecoration(
                  image: DecorationImage(image: Svg('asset/svg/icon-burger.svg', size: Size(24, 24)),),
                ),
              ),
            ),
            SizedBox(
              width: 36,
              height: 36,
              child:  GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('settings');
                },
                child:CircleAvatar(
                backgroundColor: kBlueColor,
                backgroundImage: userImage.isEmpty || userImage == 'https://img1.baidu.com/it/u=592570905,1313515675&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500'
                ? const NetworkImage('https://img1.baidu.com/it/u=592570905,1313515675&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500') as ImageProvider
                : FileImage(File(userImage)),
              ),
              ),
            ),
          ],
        );
      }
      else if(snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator(),);
      }
      else {
        return SizedBox();
      }
      }
    );
  }
}
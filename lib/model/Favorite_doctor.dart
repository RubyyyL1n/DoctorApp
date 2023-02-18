// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sqq_flutter2/constants.dart';
import 'doctors.dart';

class FavoriteDoctor extends StatefulWidget {
  const FavoriteDoctor({super.key});

  @override
  State<FavoriteDoctor> createState() => _FavoriteDoctorState();
}

class _FavoriteDoctorState extends State<FavoriteDoctor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Doctors', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: kWhiteColor),),
        leading: IconButton(icon:const Icon(Icons.arrow_back, color: kWhiteColor,), onPressed: () {Navigator.of(context).pop();},),
        backgroundColor: kGreenColor,
        shadowColor: kGreenColor,
      ),
      body: const FavoriteInfo(),
    );
  }
}


class FavoriteInfo extends StatefulWidget {
  const FavoriteInfo({super.key});

  @override
  State<FavoriteInfo> createState() => _FavoriteInfoState();
}

class _FavoriteInfoState extends State<FavoriteInfo> {
  final ref = FirebaseFirestore
  .instance
  .collection('Favorite')
  .where("userEmail", isEqualTo: FirebaseAuth.instance.currentUser!.email)
  .get();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
        child: FutureBuilder<QuerySnapshot>(
          future: ref,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if(snapshot.hasData)
              {
              final snap = snapshot.data!.docs;
              return ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 8),
              scrollDirection: Axis.vertical,
              itemCount: snap.length,
              itemBuilder: (context, index) {//没有分开独立写成一个widget
                //Doctor doc = Doctor();
                //_readDoctor(index+1, doc);
                // ignore: non_constant_identifier_names
                double Rating = snap[index]['doctorRating'];

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

                  //format of favorite doctors
                  child: Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        color: Colors.transparent,
        height: 80,
        width: MediaQuery.of(context).size.width-32,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 88,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('asset/images/${snap[index]['doctorPicture']}'))
              ),
            ),
            const SizedBox(width: 16,),
            Flexible(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snap[index]['doctorName'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.headline4,
                      ),
                      Text(
                      '${snap[index]['doctorSpecialty']} ・ ${snap[index]['doctorHospital']}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.headline5,
                      ),
                      const Spacer(),

                      SizedBox(
                        width: MediaQuery.of(context).size.width-136,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                RatingBar.builder(
                                  itemSize: 16,
                                  initialRating: Rating,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  itemCount: 5,
                                  itemPadding: EdgeInsets.zero,
                                  // ignore: avoid_types_as_parameter_names
                                  itemBuilder:(context, Null) => const Icon(
                                    Icons.star,
                                    color: kYellowColor,
                                  ),
                                  onRatingUpdate: (rating) {
                                    debugPrint(rating.toString());
                                  },
                                  unratedColor: kGreyColor600,
                                ),

                                const SizedBox(width: 4,),

                                Text(
                                  '(${snap[index]['doctorNumberOfPatient']})',
                                  style: Theme.of(context).textTheme.bodyText2)

                              ]),
                          ],
                        ),
                          ), //88+32+16
                  ],
              )),
          ],),
      ),
    ),
                );
              }
      
            );
              }
              else if(snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else{
                return const SizedBox();
              }
          }
        )
      );

  }
}


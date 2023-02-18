import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqq_flutter2/components/FavoriteDoctor.dart';
import 'package:sqq_flutter2/constants.dart';
import 'package:sqq_flutter2/model/Favorite_doctor.dart';
import 'package:sqq_flutter2/model/doctors.dart';
import 'package:sqq_flutter2/model/providerTest.dart';
import 'package:provider/provider.dart';


class DoctorDetailScreen extends StatefulWidget {
  const DoctorDetailScreen({super.key});

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  
  
  @override
  Widget build(BuildContext context) {
  final args = ModalRoute.of(context)!.settings.arguments as Doctor;
  late bool isBeenSelect;
  String? userEmail;


 @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  void _showDialog() {
  showDialog(
    context: context,
    builder: ((context) {
      return AlertDialog(
        title: Text('Congratulations!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: kBlueColor),),
        content: Text('You have collect this doctor into your Favorite Doctors, click the below button to check doctor\'s message.', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: kGreyColor700), maxLines: 3,),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: ((context) => FavoriteDoctor())));
            },
            child: Text('Check list', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: kWhiteColor)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            color: kBlueColor,
            ),
            MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: kBlueColor)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            color: kWhiteColor,
            ),

        ],
      );
    }
    )
  );
}

  Future addToFavorite() async{
    isBeenSelect = !isBeenSelect;
    userEmail = FirebaseAuth.instance.currentUser?.email;
    context.read<Favorite>().setInfo(args.doctorName, args.doctorSpecialty, args.doctorRating, args.doctorHospital, userEmail, args.doctorPicture, args.doctorNumberOfPatient, args.doctorDescription, args.doctorIsOpen, args.doctorYearOfExperience);
    context.read<Favorite>().createFavorite();
     _showDialog();
  }

  Future deleteFromFavorite() async {
    isBeenSelect = !isBeenSelect;
    userEmail = FirebaseAuth.instance.currentUser?.email;
    FirebaseFirestore.instance
    .collection('Favorite')
    .where('doctorName', isEqualTo: args.doctorName)
    .where('userEmail', isEqualTo: FirebaseAuth.instance.currentUser!.email)
    .get().then((snapshot) => snapshot.docs.first.reference.delete());
  }




    return Scaffold(
      appBar: AppBar(
        backgroundColor: kGreyColor600,
        shadowColor: Colors.transparent,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {Navigator.of(context).pop();},),
        actions: [
        StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore
        .instance
        .collection("Favorite")
        .where("doctorName", isEqualTo: args.doctorName)
        .where("userEmail", isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .snapshots(),
        builder: (context, snapshot) {
          if(snapshot.data?.docs.length != 0)
          {
          isBeenSelect = true;
          return IconButton(
            onPressed: () => deleteFromFavorite(), 
            icon: isBeenSelect ? Icon(Icons.favorite, color: kRedColor,) : Icon(Icons.favorite, color: kWhiteColor,),
            );
          }
          isBeenSelect = false;
          return IconButton(
            onPressed: () => addToFavorite(), 
            icon: isBeenSelect ? Icon(Icons.favorite, color: kRedColor,) : Icon(Icons.favorite, color: kWhiteColor,),
            );
  }
        ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
        children: [
                Container(
                  alignment: Alignment.topCenter,
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    color: kGreyColor600,
                    image: DecorationImage(image: AssetImage('asset/images/${args.doctorPicture}'), )
                  ),
        
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      ]),)
                  ),
                ),
        
                Container(
                  padding: const EdgeInsets.all(8),
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Column(children: [
                    const SizedBox(height: 24,),
        
                    Text(
                      args.doctorName,
                      style: Theme.of(context).textTheme.headline2,
                    ),
                    const SizedBox(height: 8,),
                    Text(
                      '${args.doctorSpecialty} · ${args.doctorHospital}',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    const SizedBox(height: 8,), 
                    Text(
                      '${args.doctorName} · ${args.doctorDescription}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                        color: kGreyColor700, 
                        fontFamily: GoogleFonts.sourceSansPro().fontFamily,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w400,),
                    ),
                    const SizedBox(height: 16,),
                    const Spacer(),
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text('Experience', style: Theme.of(context).textTheme.headline4!.copyWith(
                                color: kBlackColor900,
                                fontWeight: FontWeight.w400,
                              ),),
                               const SizedBox(height: 8,),
        
                               Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(args.doctorYearOfExperience, style: Theme.of(context).textTheme.headline2!.copyWith(color: kBlueColor, fontWeight: FontWeight.w400)),
                                  const SizedBox(width: 4,),
                                  Text('yr', style: Theme.of(context).textTheme.headline5,),
                                ],
                               ),
                            ],
                          ),
        
                          const SizedBox(width: 8,),
                          const VerticalDivider(
                            thickness: 1,
                            color: kGreyColor400,
                          ),
        
                          Column(
                            children: [
                              Text('Patient', style: Theme.of(context).textTheme.headline4!.copyWith(
                                color: kBlackColor900,
                                fontWeight: FontWeight.w400,
                              ),),
                               const SizedBox(height: 8,),
        
                               Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(args.doctorNumberOfPatient, style: Theme.of(context).textTheme.headline2!.copyWith(color: kBlueColor, fontWeight: FontWeight.w400)),
                                  const SizedBox(width: 4,),
                                  Text('ps', style: Theme.of(context).textTheme.headline5,),
                                ],
                               ),
                            ],
                          ),
        
                          const SizedBox(width: 8,),
                          const VerticalDivider(
                            thickness: 1,
                            color: kGreyColor400,
                          ),
        
                          Column(
                            children: [
                              Text('Rating', style: Theme.of(context).textTheme.headline4!.copyWith(
                                color: kBlackColor900,
                                fontWeight: FontWeight.w400,
                              ),),
                               const SizedBox(height: 8,),
        
                               Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(args.doctorRating.toString(), style: Theme.of(context).textTheme.headline2!.copyWith(color: kBlueColor, fontWeight: FontWeight.w400)),
                                  const SizedBox(width: 4,),
                                ],
                               ),
                            ],
                          ),
        
                        ]),
                    ),
                    
                    const Spacer(),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed('chat');
                          },
                          child:Container(
                          height: 56,
                          width: 56, 
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: kBlueColor,
                            image: const DecorationImage(image: Svg('asset/svg/icon-chat.svg', size: Size(36, 36,),color: kWhiteColor),),
                          ),
                          ),),
                         const SizedBox(width: 16),
                         Container(
                          height: 56,
                          width: MediaQuery.of(context).size.width - 104, 
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: args.doctorIsOpen ? kGreenColor : kGreyColor900,
                          ),
                          child: Center(
                            child: GestureDetector(
                              onTap: args.doctorIsOpen ? () {
                                context.read<SummaryData>().assignDoctor(args.doctorName, args.doctorSpecialty, args.doctorHospital, args.doctorPicture);
                                Navigator.of(context).pushNamed('makeAppointment');
                              } : null,
                              child: Text('Make an Appointment',
                              style: Theme.of(context).textTheme.headline4!.copyWith(
                              color: kWhiteColor, 
                              fontWeight: FontWeight.w700,),),
                            ),
                          ),
                    ),
                    ],
                    ),
                ],),
            ),
             ],
        ),
      )
          );
          }
        }




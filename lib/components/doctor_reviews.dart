import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sqq_flutter2/constants.dart';

class DoctorCompletedReview extends StatefulWidget {
  const DoctorCompletedReview({super.key});

  @override
  State<DoctorCompletedReview> createState() => _DoctorCompletedReviewState();
}

class _DoctorCompletedReviewState extends State<DoctorCompletedReview> {
  final ref = FirebaseFirestore.instance.collection('Reviews');
  final _controller = ScrollController();


  @override
  void initState() {
    // TODO: implement initState
    _controller.addListener(() {
      if(_controller.position.maxScrollExtent == _controller.offset) {}
     });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ref.snapshots(),
      builder: ((context, snapshot) {
        final snap = snapshot.data?.docs;
        if(snapshot.hasData) {
          return ListView.builder(
            controller: _controller,
            shrinkWrap: true,
            itemCount: snap!.length,
            itemBuilder: (context, index) {
              double star = snap[index]['patientStars'] == 0 ? 0 : snap[index]['patientStars'];
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                    Container(
                    height: 140,
                    width: 140,
                    decoration: BoxDecoration(image: DecorationImage(image: AssetImage('asset/images/img-men-01.png'))),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snap[index]['patientName'], 
                          style: TextStyle(fontSize: 16, color: kBlackColor800),
                          ),
                          SizedBox(height: 8,),
                              Row(
                                children: [
                                  Text('Messaging',
                                  style: TextStyle(fontSize: 12, color: kGreyColor800),),
                                  SizedBox(width: 20,),
                                  Container(
                                    height: 20,
                                    width: 80,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
                                    child: Text('${snap[index]['appointmentStatus']}', style: TextStyle(fontSize: 14, color: kBlueColor),),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10,),
                              Row(
                            children: [
                            star == 0 ? const SizedBox(height: 8,) 
                            : RatingBar.builder(
                                itemSize: 16,
                                initialRating: star,
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
                            ]),
                            ],
                          ),
                      ],
                    ),
                  SingleChildScrollView(
                      child: ExpansionTile(
                              textColor: kGreyColor700,
                              title: Text(
                                'Feedback from ${snap[index]['patientName']}', 
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: kBlackColor800),),
                                subtitle: snap[index]['patientOption'] == null
                                ? SizedBox()
                                : Text('${snap[index]['patientOption']}', 
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: kGreyColor700)),
                                children: [
                                  Text(
                                    snap[index]['patientReview'],
                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: kBlueColor),
                                  ),
                                ],
                                ),
                    )
                ],
              );
            }
          );
        }
        else if(snapshot.connectionState == ConnectionState.waiting)
        {
          return Center(child: CircularProgressIndicator(),);
        }
        else{
          return Center(child: Text('Have no Reviews yet.', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: kBlackColor900),),);
        }
      }
      
      ),
    );
  }
}


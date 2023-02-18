import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:sqq_flutter2/components/patientReview.dart';
import 'package:sqq_flutter2/constants.dart';

class MyReview extends StatefulWidget {
  String doctorImage;
  MyReview({super.key, required this.doctorImage});

  @override
  State<MyReview> createState() => _MyReviewState();
}

class _MyReviewState extends State<MyReview> {
  TextEditingController controller = TextEditingController();
  double? stars;
  
  void _submitDialog() {
  showDialog(
    context: context, 
    builder: ((context) {
      return AlertDialog(
        title: Text('Submit successfully!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: kGreenColor),),
        content: Text('We are truly appreciate for your valuable advice. Wish you good health everyday!',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: kGreenColor)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

        actions: [
          // MaterialButton(
          //   onPressed: () {
          //     Navigator.of(context).popAndPushNamed('myappointment');
          //   },
          //   child: Text('View My Reviews', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: kWhiteColor)),
          //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          //   color: kGreenColor,
          //   ),
            MaterialButton(
            onPressed: () {
              
              Navigator.of(context).popAndPushNamed('myappointment');
            },
            child: Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: kGreenColor)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            color: kWhiteColor,
            ),
        ],
      );
    }
    )
    );
    }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: kWhiteColor,)),
          title: Text('Leave a Review', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: kWhiteColor),),
          backgroundColor: kGreenColor,
          shadowColor: kGreenColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                      child: 
                        CircleAvatar(
                          radius: 80,
                          backgroundImage: AssetImage('asset/images/${widget.doctorImage}'),
                          backgroundColor: kGreyColor800,
                        ),
                    ),
              SizedBox(height: 16,),
              const Text('How was your experience with ', maxLines: 2, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: kBlackColor900),),
              Center(child: Text('${context.read<Review>().doctorName}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: kBlackColor900)),),
              const SizedBox(height: 20,),
              RatingBar.builder(
                                itemSize: 60,
                                initialRating: 1,
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
                                  setState(() {
                                    stars = rating;
                                  });
                                },
                                unratedColor: kGreyColor600,
                              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Write Your Review', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: kBlackColor900),),
                ],
              ),
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: controller,
                  maxLines: 8,
                  decoration: InputDecoration(
                    hintText: 'Please write down your experience about this appointment.....',
                    border: InputBorder.none,
                    fillColor: kGreyColor400,
                    filled: true,
                  ),
                ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () {
                  context.read<Review>().setReview(controller.text, stars!);
                  context.read<Review>().createReviews();
                  FirebaseFirestore.instance.collection('Appointments').doc(context.read<Review>().appointmentID).delete();
                  _submitDialog();
                },
                child: Center(
                  child: Text(
                    'Submit',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: kWhiteColor),
                    ),
                    ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGreenColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
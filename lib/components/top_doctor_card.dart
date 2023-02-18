import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sqq_flutter2/constants.dart';


class TopDoctorsCard extends StatelessWidget {
  const TopDoctorsCard({super.key, required this.snap, required this.index});

  final List<QueryDocumentSnapshot<Object?>> snap;
  final index;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                                  initialRating: snap[index]['doctorRating'],
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
                          Container(
                            height: 24,
                            padding: EdgeInsets.symmetric(
                                horizontal: 13,
                                vertical: 3
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: snap[index]['doctorIsOpen']?kGreenLightColor:kRedLightColor,
                            ),
                            child: Text(
                              snap[index]['doctorIsOpen']?'Open':'Close',
                              style: Theme.of(context).textTheme.headline6!.copyWith(color: snap[index]['doctorIsOpen']?kGreenColor:kRedColor),
                            ),
                          ),
                        ],
                      ),
                    ), //88+32+16
                  ],
                )),
          ],),
      ),
    );
  }
}
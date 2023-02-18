import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sqq_flutter2/constants.dart';

class UserNotification extends StatefulWidget {
  const UserNotification({super.key});

  @override
  State<UserNotification> createState() => _UserNotificationState();
}

class _UserNotificationState extends State<UserNotification> {
  final ref = FirebaseFirestore.instance.collection('Notifications').where('userEmail', isEqualTo: FirebaseAuth.instance.currentUser!.email);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: kBlackColor900,)),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          title: Text('My Notifications', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: kBlackColor900),),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: ref.snapshots(),
        builder: ((context, snapshot) {
          final snap = snapshot.data?.docs;
          if(snapshot.hasData) {
            return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: snap!.length,
                  itemBuilder: ((context, index) {
                    String title = snap[index]['title'].substring(9);
                    return Dismissible(
              movementDuration: const Duration(seconds: 1),
              resizeDuration: const Duration(seconds: 1),
              onDismissed: (direction) {
                debugPrint('Operation After dismissed');
              },
              dismissThresholds: const {DismissDirection.endToStart: 0.5},
              background: const Center(
                child: Icon(Icons.delete),
              ),
              confirmDismiss: (donext) async {
                var result = await showDialog(
                  context: context, 
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 10,
                      content: const Text('Are you sure to delete?'),
                      actions: [
                        ElevatedButton(onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                         child: const Text('No')),
                         ElevatedButton(onPressed: () {
                          FirebaseFirestore.instance.collection('Notifications').doc(snap[index]['notificationID']).delete();
                          Navigator.of(context).pop(true);
                        },
                         child: const Text('Yes')),
                      ],
                    );
                  }
                  );
                  return result ?? false;
              },
                    key: ValueKey(index),
                    
                    child: GestureDetector(
                      
                      child: Container(
                        key: ValueKey(index),
                        height: 160,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                title == 'Success'
                                ? const CircleAvatar(
                                  backgroundColor: Color.fromARGB(255, 157, 255, 160),
                                  child: Icon(Icons.schedule, color: kGreenColor,),
                                )
                                : title == 'Changed'
                                ? const CircleAvatar(
                                  backgroundColor: Color.fromARGB(255, 133, 196, 248),
                                  child: Icon(Icons.schedule, color: kBlueColor,))
                                : title == 'Cancelled'
                                ? const CircleAvatar(
                                  backgroundColor: Color.fromARGB(255, 252, 138, 130),
                                  child: Icon(Icons.highlight_off, color: kRedColor,),)
                                : const SizedBox(),
                                SizedBox(width: 10,),
                                Column(
                                  children: [
                                    Text(
                                      snap[index]['title'],
                                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: kBlackColor800),
                                    ),
                                    Text(
                                      snap[index]['currentTime'],
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: kGreyColor900),
                                    )
                                  ],
                                ),
                                const SizedBox(width: 80,),
                              ],
                            ),
                            Expanded(
                              child: Text(
                                snap[index]['content'],
                                style: TextStyle(color: kGreyColor800, fontSize: 18, fontWeight: FontWeight.w500),
                                maxLines: 4,
                                ),
                                ),
                                const SizedBox(height: 10,),
                          ],
                        ),),
                    )
                    );
                  }
                  )
                  ),
              );
          }
          else if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
          }
          else {
            return SizedBox();
          }
        }
        )
        ),
    );
  }
}
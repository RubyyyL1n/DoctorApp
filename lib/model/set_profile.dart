import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Profile{
  Profile(
    {
      this.userName = '',
      this.userNickName = '',
      this.userDOB = '',
      this.userEmail = '',
      this.userGender = '',
      this.userImage = '',

    }
  );
  
  String userName;
  String userNickName;
  String userEmail;
  String userGender;
  String userDOB;
  String userImage;

  Map<String, dynamic> ToFirestore() => {
    'userName': userName,
    'userNickName': userNickName,
    'userEmail': userEmail,
    'userGender': userGender,
    'userDOB': userDOB,
    'userImage': userImage,
  };

  factory Profile.FromFirebase(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions options) {
  final Data = snapshot.data();

  return Profile(
    userName: Data?['userName'],
    userEmail: Data?['userEmail'],
    userGender: Data?['userGender'],
    userDOB: Data?['userDOB'],
    userImage: Data?['userImage'],
  );
}

void setUser(String userEmail) {
  this.userEmail = userEmail;
  createProfile();
}

Future createProfile() async {
  final docUser = FirebaseFirestore.instance.collection('Profiles').doc(userEmail.toString());
    docUser.set(ToFirestore());
  }

}






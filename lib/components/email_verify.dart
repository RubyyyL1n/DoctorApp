import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sqq_flutter2/components/signup_error.dart';
import 'package:sqq_flutter2/home_screen.dart';


class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResentEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if(!isEmailVerified){
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose(){
    timer?.cancel();
    super.dispose();
  }

  Future sendVerificationEmail() async {
    try {
          final user = FirebaseAuth.instance.currentUser;
          await user?.sendEmailVerification();

          setState(() => canResentEmail = false);
          await Future.delayed(const Duration(seconds: 5));
          setState(() => canResentEmail = true);
} catch (e) {
  Utils.showSnackBar(e.toString());
}
  }

  Future checkEmailVerified() async {
    //call after email verification
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if(isEmailVerified) timer?.cancel();
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
  ? HomeScreen()
  : Scaffold(
    body: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'A Verification email has been sent to your email.',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24,),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
            onPressed: canResentEmail ? sendVerificationEmail : null,
            icon: Icon(Icons.email, size: 32),
            label: Text(
              'Resent Email',
              style: TextStyle(fontSize: 24),)),
            SizedBox(height: 8,),
            TextButton(
            style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
            onPressed: () => FirebaseAuth.instance.signOut(),
            child: Text(
              'Cancel',
              style: TextStyle(fontSize: 24),))
         ],)
          ),
      );
}
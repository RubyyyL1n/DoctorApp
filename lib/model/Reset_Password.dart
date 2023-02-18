import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:sqq_flutter2/components/signup_error.dart';
import 'package:sqq_flutter2/constants.dart';
import 'package:sqq_flutter2/model/Appointment_detail.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose(){
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: kBlackColor900,), onPressed: () { Navigator.pop(context); },),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 80,),
              Container(
              width: 290,
              height: 290,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('asset/signup/img-forgot.png'))
              ),
            ),
            const SizedBox(height: 20,),
              const Text(
                'Receive an email to\nreset your password',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: emailController,
                cursorColor: kWhiteColor,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(labelText: 'Email'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) => 
                    email != null && !EmailValidator.validate(email)
                    ? 'Enter a valid email'
                    : null,
              ),
              SizedBox(height: 20,),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: resetPassword, 
                icon: Icon(Icons.email_outlined), 
                label: Text(
                  'Reset Password',
                  style: TextStyle(fontSize: 24),
                ),),
            ],)),),
    ),
    );
  }

  Future resetPassword() async {

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator(),));

    try {
  await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
  
  Utils.showSnackBar('Password Reset Email sent');
  Navigator.of(context).popUntil((route) => route.isFirst);
} on FirebaseAuthException catch (e) {
  print(e);
  Utils.showSnackBar(e.message);
  Navigator.of(context).pop();
  // TODO
}
  }
}
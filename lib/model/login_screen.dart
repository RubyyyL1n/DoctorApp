import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:sqq_flutter2/constants.dart';
import 'package:sqq_flutter2/main.dart';
import 'package:sqq_flutter2/model/signin.dart';

import '../components/signup_error.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  @override
  Widget build(BuildContext context) => isLogin
  ? LoginWidget(onClickedSignUp: toggle) : SignUpWidget(onClickedSignIn: toggle);
  void toggle() => setState(() => isLogin = !isLogin);
}



class SignUpWidget extends StatefulWidget {
  final Function() onClickedSignIn;

@override
  const SignUpWidget({super.key, required this.onClickedSignIn});

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final formKey = GlobalKey<FormState>();
  final _userAccountController = TextEditingController();
  final _userEmailController = TextEditingController();
  final _userMobileController = TextEditingController();
  final _userPaswordController = TextEditingController();
  var passwordVisible;
  
  void initState() {
    passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      body: SingleChildScrollView(
      child: Form(
        key: formKey,
        child:Column(
        children:[
          SizedBox(height: 60),
          Padding(
            padding: EdgeInsets.only(left: 10, right:320),
          //   child:GestureDetector(
          //     onTap: () {
          //       Navigator.of(context).popUntil((route) => route.isFirst);},
          //     child:Container(
          //   height:44,
          //   width: 44,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(90),
          //     color: kGreenColor,
          //     ),
          //     child: const Icon(
          //       Icons.arrow_left_sharp,
          //       color: kWhiteColor,
          //       size: 22.0,
          //       ),
          //     ),
          // ),
          ),
          
          const SizedBox(height: 50),

          Row(
              children: [
                Padding(padding: EdgeInsets.only(right:45)),
                Text(
                'Sign up',
                style: Theme.of(context).textTheme.headline2,
                textAlign: TextAlign.end,
                ),
                ]
          ),
          const SizedBox(height: 25),
          Row(
              children: [
                Padding(padding: EdgeInsets.only(right:45)),
                Text(
                'Create an account here',
                style: Theme.of(context).textTheme.bodyText1?.copyWith(color: kGreyColor900, fontSize: 15),
                textAlign: TextAlign.end,
                ),
                ]
          ),

          const SizedBox(height: 10),
              Row(
                children: [
                Padding(padding: EdgeInsets.only(left: 60)),
                Container(
                  width: 300,
                  height: 24,
                  child: 
                TextField(
                  //autofocus: true,
                  controller: _userAccountController,
                  decoration: InputDecoration(
                    labelText: 'Account', 
                    //border: OutlineInputBorder(),
                    //hintText: 'Input your account',
                    prefixIcon: Padding(padding: EdgeInsets.zero, child: Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(image: Svg('asset/signup/img-account.svg', size: Size(24,24))),
                    ),)
                  ),
                )
                ),
                ),
                SizedBox(height: 65,),
                
              ],),

              Row(
                children: [
                Padding(padding: EdgeInsets.only(left: 60)),
                Container(
                  width: 300,
                  height: 24,
                  child: 
                TextField(
                  //autofocus: true,
                  controller: _userMobileController,
                  decoration: InputDecoration(
                    labelText: 'Mobile Number', 
                    //border: OutlineInputBorder(),
                    //hintText: 'Input your account',
                    prefixIcon: Padding(padding: EdgeInsets.zero, child: Container(
                      height: 27,
                      width: 24,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(image: Svg('asset/signup/img-mobile.svg', size: Size(24,24))),
                    ),)
                  ),
                )
                ),
                ),
                SizedBox(height: 65,),
                
              ],),

              Row(
                children: [
                Padding(padding: EdgeInsets.only(left: 60)),
                Container(
                  width: 300,
                  height: 24,
                  child: 
                TextFormField(
                  //autofocus: true,
                  controller: _userEmailController,
                  decoration: InputDecoration(
                    labelText: 'Email', 
                    //border: OutlineInputBorder(),
                    //hintText: 'Input your account',
                    prefixIcon: Padding(padding: EdgeInsets.zero, child: Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(image: Svg('asset/signup/img-message.svg', size: Size(24,24))),
                    ),
                    )
                  ),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) =>
                        email != null && !EmailValidator.validate(email) ? 'Enter a valid email' : null,
                ),
                ),
                SizedBox(height: 65,),
                
              ],),

              Row(
                children: [
                Padding(padding: EdgeInsets.only(left: 60)),
                Container(
                  width: 300,
                  height: 24,
                  child: 
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _userPaswordController,
                  obscureText: passwordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password', 
                    //border: OutlineInputBorder(),
                    //hintText: 'Input your account',
                      suffixIcon: IconButton(
                        icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off), 
                        color: kGreyColor900,
                        padding: EdgeInsets.only(bottom: 8),
                        //iconSize: 24,
                        onPressed: () {
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },),
                      prefixIcon: Padding(padding: EdgeInsets.zero, child: Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(image: Svg('asset/signup/img-passwd.svg', size: Size(24,24))),
                      
                    ),
                    ),
                  ),
                ),
                autovalidateMode:AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 6 ? 'Enter min. 6 characters' : null,
                ),
                ),
                const SizedBox(height: 65,),
                ],),
              Row(
              children: [
                Padding(padding: EdgeInsets.only(right:60)),
                Text(
                'By signing up you agree with our Terms of use',
                style: Theme.of(context).textTheme.bodyText1?.copyWith(color: kBlackColor800, fontSize: 15),
                textAlign: TextAlign.end,
                ),
                ]

          ),
          const SizedBox(height: 50,),

              Row(children: [
                Padding(padding: EdgeInsets.only(left: 30)),
                GestureDetector(
                  onTap: signUp,
                  child: Container(
                  padding: EdgeInsets.only(top: 10),
                  height: 60,
                  width: 354,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: kGreenColor,
                    ),
                    child: Text(
                      'Sign UP',
                      style: Theme.of(context).textTheme.headline2?.copyWith(fontSize: 30, color: kWhiteColor),
                      textAlign: TextAlign.center,
                    ),
                ),)
              ],),

              SizedBox(height: 16,),
              Row(
                children: [
                  const Padding(padding: EdgeInsets.only(right: 70)),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: kGreyColor800, fontSize: 20),
                      text: 'Already have account? ',
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickedSignIn,
                          text: 'Sign in',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: kGreenColor,
                          )
                        )
                      ]
                    )),
                ],
              )
            ],
          ),
        
      ),
      ),
      );

  }

  Future signUp() async {

    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator(),));
  try {
  await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: _userEmailController.text.trim(), 
    password: _userPaswordController.text.trim());
} on FirebaseAuthException catch (e) {
  print(e);
  Utils.showSnackBar(e.message);
  // TODO
}

navigatorKey.currentState!.popUntil((route) => route.isFirst);
}
}


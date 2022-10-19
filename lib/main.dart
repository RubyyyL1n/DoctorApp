import 'package:flutter/material.dart';
import 'package:sqq_flutter2/components/signup_error.dart';
import 'package:sqq_flutter2/doctor_app_theme.dart';
import 'package:sqq_flutter2/model/doctors.dart';
import 'package:sqq_flutter2/model/login_screen.dart';
import 'package:sqq_flutter2/model/signin.dart';
import 'home_screen.dart';
import 'doctor_detail_screen.dart';
import 'package:firebase_core/firebase_core.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  GenerateDoctorDatabase();

  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: Utils.messengerKey,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: DoctorAppTheme.lightTheme,
      initialRoute: 'signin',
      routes: {
        '/':(context) => const HomeScreen(),
        'doctor_details':(context) => const DoctorDetailScreen(),
        'Auth':(context) => const AuthPage(),
        'signin':(context) => const SignInPage(),
      }
    );
  }
}
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqq_flutter2/components/FavoriteDoctor.dart';
import 'package:sqq_flutter2/components/doctorTime.dart';
import 'package:sqq_flutter2/components/myNotification.dart';
import 'package:sqq_flutter2/components/patientReview.dart';
import 'package:sqq_flutter2/components/profile.dart';
import 'package:sqq_flutter2/components/signup_error.dart';
import 'package:sqq_flutter2/doctor_app_theme.dart';
import 'package:sqq_flutter2/model/Reset_Password.dart';
import 'package:sqq_flutter2/model/admin_home_page.dart';
import 'package:sqq_flutter2/model/chat.dart';
import 'package:sqq_flutter2/model/login_screen.dart';
import 'package:sqq_flutter2/model/makeAppoinment.dart';
import 'package:sqq_flutter2/model/medicine.dart';
import 'package:sqq_flutter2/model/myAppointment.dart';
import 'package:sqq_flutter2/model/providerTest.dart';
import 'package:sqq_flutter2/model/setting.dart';
import 'package:sqq_flutter2/model/signin.dart';
import 'package:sqq_flutter2/model/test.dart';
import 'home_screen.dart';
import 'doctor_detail_screen.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handing a background message ${message.messageId}');
}


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //GenerateDoctorDatabase();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SummaryData()),
        ChangeNotifierProvider(create: (_) => Favorite()),
        ChangeNotifierProvider(create: (_) => Review()),
        ChangeNotifierProvider(create: (_) => MyNotification()),
        ChangeNotifierProvider(create: (_) => TimeSelection()),
      ],
      child: const MyApp(),
    )
    );
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
      initialRoute: 'signin',//设置初始进入的路径
      routes: {
        '/':(context) => const HomeScreen(),//登录状态下默认的路径
        'doctor_details':(context) => const DoctorDetailScreen(),
        'Auth':(context) => const AuthPage(),
        'signin':(context) => const SignInPage(),
        'reset':(context) => const ForgotPasswordPage(),
        'profile':(context) => const ProfileRegisterPage(),
        'test':(context) => const TestPage(),
        'chat':(context) => const ChatPage(),
        'settings':(context) => const SettingsPage(),
        'myappointment':(context) => const MyAppointment(),
        'makeAppointment':(context) => const MakeAppointment(),
        'admin':(context) => const AdminHomePage(), 
        'Medicines':(context) => const Medicines(),
      }
    );
  }
}
import 'package:flutter/material.dart';
import 'package:sqq_flutter2/components/doctor_appointment.dart';
import 'package:sqq_flutter2/components/doctor_calendar.dart';
import 'package:sqq_flutter2/components/doctor_profile.dart';
import 'package:sqq_flutter2/components/doctor_reviews.dart';
import 'package:sqq_flutter2/constants.dart';


class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _currentIndex = 0;
  List<Widget> body = const [
    DoctorAppointment(),
    Calendar(),
    DoctorCompletedReview(),
    DoctorProfileRegisterPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Home Page',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back,color: kWhiteColor,), onPressed: () {Navigator.of(context).popAndPushNamed('/');},),
        backgroundColor: kGreenColor,
      ),
      body: SingleChildScrollView(
        child: body[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: kGreyColor900,
        fixedColor: kGreenColor,
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        items: [
          BottomNavigationBarItem(
            label: "Appointments",
            icon: Icon(Icons.file_copy),
            ),
            BottomNavigationBarItem(
            label: "Calendar",
            icon: Icon(Icons.menu),
            ),
            BottomNavigationBarItem(
            label: "Reviews",
            icon: Icon(Icons.reviews
            ),
            ),
            BottomNavigationBarItem(
            label: "Profiles",
            icon: Icon(Icons.person),
            ),
        ],
      ),
    );
    
  }
}
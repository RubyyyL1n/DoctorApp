import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Page"),
      ),
      body: 
      Padding(padding: EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Sign in as',
          style: TextStyle(fontSize: 16),),
          SizedBox(height: 8,),
          Text(
            user.email!,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
          ),
          SizedBox(
            height: 40,
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).popAndPushNamed('signin');
              },
            icon: Icon(Icons.arrow_back, size: 32,), 
            label: Text('Sign out', style: TextStyle(fontSize: 24),))
        ]),
      ),
    );
  }
}

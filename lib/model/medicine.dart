import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sqq_flutter2/constants.dart';


class Medicines extends StatefulWidget {
  const Medicines({super.key});

  @override
  State<Medicines> createState() => _MedicinesState();
}

class _MedicinesState extends State<Medicines> with SingleTickerProviderStateMixin{

  final List<Tab> medMenu = <Tab> [
    Tab(child: Text('Gastric', style: TextStyle(color: kBlackColor800, fontSize: 16),)),
    Tab(child: Text('Analgesics', style: TextStyle(color: kBlackColor800, fontSize: 16),)),
    Tab(child: Text('Antipyretic', style: TextStyle(color: kBlackColor800, fontSize: 16),)),
    
  ];


  int selectedIndex = 0;
  PageController controller = PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back, color: kWhiteColor,), onPressed: () {
          Navigator.pop(context);
        },),
        title: Text('Medicines', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: kWhiteColor),),
        backgroundColor: kGreenColor,
      ),
      body: SafeArea(
        child: Row(
          children: [
            Container(
              width: 70,
              child: ListView.separated(
                itemBuilder: ((context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                        controller.jumpToPage(index);
                      });
                    },
                    child: Container(
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            color: kBlueColor,
                            width: 5,
                            height: selectedIndex == index ? 80 : 0,
                            ),
                          Expanded(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              alignment: Alignment.center,
                              height: 80,
                              color: selectedIndex == index ? Colors.blueGrey.withOpacity(0.2) : Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                child: medMenu[index],
                              ),)),
                        ],
                      ),
                    ),
                  );
                }), 
                separatorBuilder: ((context, index) {
                  return SizedBox(height: 5,);
                }), 
                itemCount: medMenu.length),
            ),
            Expanded(
              child: PageView(
                controller: controller,
                children: [
                  Gastric(),
                  Analgesics(),
                  Antipyretic(),
                ]),
            )
          ],
        ),
      ),
    );
  }
}


class Analgesics extends StatefulWidget {
  const Analgesics({super.key});

  @override
  State<Analgesics> createState() => _AnalgesicsState();
}

class _AnalgesicsState extends State<Analgesics> {
  final _controller = ScrollController();
  final ref = FirebaseFirestore.instance.collection('Medicines').where('medType', isEqualTo: 'Analgesics');

  @override
  void initState() {
    // TODO: implement initState
    _controller.addListener(() {
      if(_controller.position.maxScrollExtent == _controller.offset) {}
     });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: ref.snapshots(),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          final snap = snapshot.data?.docs;
          return SingleChildScrollView(
            child: ListView.builder(
              controller: _controller,
              shrinkWrap: true,
              itemCount: snap!.length,
              itemBuilder: ((context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(  
                          image: DecorationImage(image: NetworkImage('${snap[index]['medImage']}')),
                        ),
                      ),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(snap[index]['medName'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: kBlackColor900),),
                            ],
                          ),
                          const SizedBox(height: 8,),
                          Text(snap[index]['medDescrp'], style: TextStyle(fontSize: 14, color: kGreyColor900)),
                          const SizedBox(height: 8,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(snap[index]['medPrice'], style: TextStyle(fontSize: 20, color: kRedColor),)
                            ],
                          )
                        ],
                      ),
                    ),
                    ],
                  ),
                );
              })
              ),
          );
        }
        else if(snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(),);
        }
        else{
          return SizedBox();
        }
      },
    );
  }
}

class Antipyretic extends StatefulWidget {
  const Antipyretic({super.key});

  @override
  State<Antipyretic> createState() => _AntipyreticState();
}

class _AntipyreticState extends State<Antipyretic> {
  final _controller = ScrollController();
  final ref = FirebaseFirestore.instance.collection('Medicines').where('medType', isEqualTo: 'Antipyretic');

  @override
  void initState() {
    // TODO: implement initState
    _controller.addListener(() {
      if(_controller.position.maxScrollExtent == _controller.offset) {}
     });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: ref.snapshots(),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          final snap = snapshot.data?.docs;
          return SingleChildScrollView(
            child: ListView.builder(
              controller: _controller,
              shrinkWrap: true,
              itemCount: snap!.length,
              itemBuilder: ((context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(  
                          image: DecorationImage(image: NetworkImage('${snap[index]['medImage']}')),
                        ),
                      ),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(snap[index]['medName'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: kBlackColor900),),
                            ],
                          ),
                          const SizedBox(height: 8,),
                          Text(snap[index]['medDescrp'], style: TextStyle(fontSize: 14, color: kGreyColor900)),
                          const SizedBox(height: 8,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(snap[index]['medPrice'], style: TextStyle(fontSize: 20, color: kRedColor),)
                            ],
                          )
                        ],
                      ),
                    ),
                    ],
                  ),
                );
              })
              ),
          );
        }
        else if(snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(),);
        }
        else{
          return SizedBox();
        }
      },
    );
  }
}


class Gastric extends StatefulWidget {
  const Gastric({super.key});

  @override
  State<Gastric> createState() => _GastricState();
}

class _GastricState extends State<Gastric> {
  final _controller = ScrollController();
  final ref = FirebaseFirestore.instance.collection('Medicines').where('medType', isEqualTo: 'Gastric');

  @override
  void initState() {
    // TODO: implement initState
    _controller.addListener(() {
      if(_controller.position.maxScrollExtent == _controller.offset) {}
     });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: ref.snapshots(),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          final snap = snapshot.data?.docs;
          return SingleChildScrollView(
            child: ListView.builder(
              controller: _controller,
              shrinkWrap: true,
              itemCount: snap!.length,
              itemBuilder: ((context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(  
                          image: DecorationImage(image: NetworkImage('${snap[index]['medImage']}')),
                        ),
                      ),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(snap[index]['medName'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: kBlackColor900),),
                            ],
                          ),
                          const SizedBox(height: 8,),
                          Text(snap[index]['medDescrp'], style: TextStyle(fontSize: 14, color: kGreyColor900)),
                          const SizedBox(height: 8,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(snap[index]['medPrice'], style: TextStyle(fontSize: 20, color: kRedColor),)
                            ],
                          )
                        ],
                      ),
                    ),
                    ],
                  ),
                );
              })
              ),
          );
        }
        else if(snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(),);
        }
        else{
          return SizedBox();
        }
      },
    );
  }
}
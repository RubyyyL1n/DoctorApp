import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:sqq_flutter2/constants.dart';

class HomeScreenNavbar extends StatelessWidget {
  const HomeScreenNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 24,
          width: 24,
          decoration: const BoxDecoration(
            image: DecorationImage(image: Svg('asset/svg/icon-burger.svg', size: Size(24, 24)),),
          ),
        ),
        const SizedBox(
          width: 36,
          height: 36,
          child:  CircleAvatar(
            backgroundColor: kBlueColor,
            backgroundImage: NetworkImage('https://img1.baidu.com/it/u=592570905,1313515675&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500'),
          ),
        ),
      ],
    );
  }
}
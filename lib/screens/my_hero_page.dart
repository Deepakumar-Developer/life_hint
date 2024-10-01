import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notes_hint/colors.dart';
import 'package:notes_hint/functions.dart';
import 'package:notes_hint/screens/page_desider.dart';

class MyHeroPage extends StatefulWidget {
  const MyHeroPage({super.key});

  @override
  State<MyHeroPage> createState() => _MyHeroPageState();
}

class _MyHeroPageState extends State<MyHeroPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PageGate()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    customStatusBar();
    return Scaffold(
      backgroundColor: color_60,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgPicture.asset(
                'assets/images/welcome.svg',
                semanticsLabel: 'Your image description',
                width: 250,
                height: 250,
              ),
              Column(
                children: [
                  Text(
                    'Life Hint',
                    style: TextStyle(
                      color: colorOthers,
                      fontSize: 22.5,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(
                    height: 12.5,
                  ),
                  Text(
                    'Make your Instance as Hint',
                    style: TextStyle(
                      color: colorOthers.withOpacity(0.6),
                      fontSize: 15.5,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.75,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 80,
                child: LinearProgressIndicator(
                  color: color_30.withOpacity(0.5),
                  backgroundColor: color_30.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

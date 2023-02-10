import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mellow_songs/consts/colors.dart';
import 'package:mellow_songs/views/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MellowSONGS',
      home: const Home(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColor.bgDarkColor,
        fontFamily: "SofiaSans",
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
    );
  }
}

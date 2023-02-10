import 'package:flutter/material.dart';
import 'package:mellow_songs/consts/colors.dart';

const String sofiaSans = "SofiaSans";

ourStyle(
    {double? size = 14,
    Color color = AppColor.whiteColor,
    String family = sofiaSans,
    FontWeight fontWeight = FontWeight.normal}) {
  return TextStyle(
    fontSize: size,
    fontFamily: family,
    color: color,
    fontWeight: fontWeight,
  );
}

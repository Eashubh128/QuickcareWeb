import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IconTextPair extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color iconColor;
  final TextStyle textStyle;

  const IconTextPair({
    Key? key,
    required this.text,
    required this.icon,
    required this.iconColor,
    required this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text, style: textStyle),
        SizedBox(width: 3.w),
        Icon(icon, size: 20.w, color: iconColor),
      ],
    );
  }
}

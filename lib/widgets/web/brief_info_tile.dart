import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BriefInfoTile extends StatefulWidget {
  const BriefInfoTile(
      {super.key,
      required this.headerWidget,
      required this.subTitleText,
      required this.titleText,
      required this.backgroundColor,
      required this.textColor});
  final Widget headerWidget;
  final String titleText;
  final String subTitleText;
  final Color backgroundColor;
  final Color textColor;

  @override
  State<BriefInfoTile> createState() => _BriefInfoTileState();
}

class _BriefInfoTileState extends State<BriefInfoTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      width: double.infinity,
      height: 67.h,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
              radius: 35,
              backgroundColor: const Color(
                0XFF32A7E2,
              ),
              child: widget.headerWidget),
          SizedBox(
            width: 8.w,
          ),
          Text(
            widget.titleText,
            style: TextStyle(
                color: widget.textColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400),
          ),
          const Spacer(),
          Text(
            widget.subTitleText,
            style: TextStyle(
                color: widget.textColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class ChartNavigationUI extends StatefulWidget {
//   final Function(String frequency, int offset) onFilterChange;

//   ChartNavigationUI({required this.onFilterChange});

//   @override
//   _ChartNavigationUIState createState() => _ChartNavigationUIState();
// }

// class _ChartNavigationUIState extends State<ChartNavigationUI> {
//   String _selectedFrequency = 'Daily';
//   int _offset = 0;

//   void _updateChart() {
//     widget.onFilterChange(_selectedFrequency, _offset);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             setState(() {
//               _offset++;
//               _updateChart();
//             });
//           },
//         ),
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: 16.0.w),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(30.0.w),
//             border: Border.all(color: Colors.white, width: 1.0),
//             color: const Color.fromARGB(255, 214, 214, 214),
//           ),
//           child: DropdownButton<String>(
//             value: _selectedFrequency,
//             icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
//             iconSize: 24.w,
//             elevation: 16,
//             underline: Container(),
//             dropdownColor: const Color.fromARGB(255, 214, 214, 214),
//             style: const TextStyle(color: Colors.black),
//             onChanged: (newValue) {
//               setState(() {
//                 _selectedFrequency = newValue!;
//                 _offset = 0;
//                 _updateChart();
//               });
//             },
//             items: <String>['Daily', 'Weekly', 'Monthly']
//                 .map<DropdownMenuItem<String>>((String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(value),
//               );
//             }).toList(),
//           ),
//         ),
//         IconButton(
//           icon: const Icon(Icons.arrow_forward),
//           onPressed: _offset > 0
//               ? () {
//                   setState(() {
//                     _offset--;
//                     _updateChart();
//                   });
//                 }
//               : null,
//         ),
//       ],
//     );
//   }
// }

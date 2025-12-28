import 'package:flutter/material.dart';

class LearnWrap extends StatelessWidget {
  LearnWrap({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(color: Colors.white, child: _rightApproach()),
      ),
    );
  }

  Widget _wrongApproach() {
    return Row(
      children: [
        Chip(label: Text("Flutter")),
        Chip(label: Text("Dart")),
        Chip(label: Text("VeryLongTechnologyName")),
      ],
    );
  }

  Widget _rightApproach() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        Chip(label: Text("Flutter")),
        Chip(label: Text("Dart")),
        Chip(label: Text("VeryLongTechnologyName")),
      ],
    );
  }
}

// class LearningChipState extends StatefulWidget {
//   const LearningChipState({super.key});

//   @override
//   State<LearningChipState> createState() => _LearningChipStateState();
// }

// class _LearningChipStateState extends State<LearningChipState> {
//   bool _selected = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Container(color: Colors.white, child: _rightApproach()),
//       ),
//     );
//   }

//   Widget _rightApproach() {
//     return Wrap(
//       spacing: 8.0,
//       runSpacing: 8.0,
//       children: [
//         FilterChip(
//           label: Text("Flutter"),
//           selected: _selected,
//           onSelected: (value) {
//             setState(() {
//               _selected = value;
//             });
//           },
//         ),
//         Chip(label: Text("Dart")),
//         Chip(label: Text("VeryLongTechnologyName")),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';

class LearnExpanded extends StatelessWidget {
  const LearnExpanded({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: MyCard()));
  }
}

class MyCard extends StatelessWidget {
  const MyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      elevation: 6,
      shadowColor: Colors.grey,
      child: Column(
        mainAxisSize: .min,
        children: [Padding(padding: const EdgeInsets.all(8.0), child: _myCardContent())],
      ),
    );
  }

  Widget _myCardContent() {
    return Row(
      children: [
        CircleAvatar(radius: 40,),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            loremIpsum(paragraphs: 2, words: 20),
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontFamily: "Times New Roman",
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text("${DateTime.now().day}/${DateTime.now().month}"),
      ],
    );
  }
}

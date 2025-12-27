import 'package:flutter/material.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';

class LearnFlexible extends StatelessWidget {
  const LearnFlexible({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.white, child: _goodAlternative());
  }

  Widget _strangeApproach() {
    return Row(
      children: [
        Flexible(fit: FlexFit.tight, child: Text("short")),
        Icon(Icons.ac_unit_sharp),
      ],
    );
  }

  Widget _goodApproach() {
    return Container(
      margin: EdgeInsets.all(16.0),
      child: Row(
        children: [
          Flexible(child: Text(style: commonTextStyle(), loremIpsum(paragraphs: 2, words: 20))),

          // Icon(Icons.ac_unit_sharp),
          Flexible(child: Text(style: commonTextStyle(), loremIpsum(paragraphs: 2, words: 20))),
        ],
      ),
    );
  }

  Widget _goodAlternative() {
    return Row(
      children: [
        CircleAvatar(),
        SizedBox(width: 8),
        Flexible(
          child: Text(style: commonTextStyle(), loremIpsum(), maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
        Icon(Icons.more_vert),
      ],
    );
  }

  TextStyle commonTextStyle() {
    return TextStyle(
      fontSize: 16,
      color: Colors.grey,
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.none,
      fontFamily: 'Times New Roman',
    );
  }
}

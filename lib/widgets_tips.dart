import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: Text("data")),
        Expanded(child: Text("data")),
        Flexible(child: Text("I don't know about your featA")),
        Flexible(child: Text("I don't know about your commits on featA")),
        Flexible(child: TextButton(onPressed: () {}, child: Text("feat click"))),
        Text("develop saved trying to clear history with reset"),
        Text("1"),
        Text("2"),
        Text("3")
      ],
    );
  }
}

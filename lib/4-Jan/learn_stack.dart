import 'package:flutter/material.dart';

class LearnStack extends StatelessWidget {
  const LearnStack({super.key});

  @override
  Widget build(BuildContext context) {
    return _simpleStack();
  }

  Container _simpleStack() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Stack(
          children: [
            CircleAvatar(radius: 40),
            Positioned(
              width: 50,
              height: 50,
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onDoubleTap: () {
                  debugPrint("Tapped dd");
                },
                child: Icon(Icons.draw),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Container _badStack() {
  //   return Container(
  //     color: Colors.white,
  //     child: Center(
  //       child: Stack(
  //         children: [
  //           Expanded(child: Text('Loôoooooooong text')),
  //           // ❌
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

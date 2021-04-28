import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 1,
          color: Colors.grey,
        ),
        SizedBox(
          width: 8,
        ),
        Text(
          'або',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(
          width: 8,
        ),
        Container(
          width: 80,
          height: 1,
          color: Colors.grey,
        ),
      ],
    );
  }
}

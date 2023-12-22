import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HeadingWidget extends StatelessWidget {
  final String headingText;
  final String buttonText;
  final VoidCallback onTap;

  const HeadingWidget({super.key, required this.headingText, required this.buttonText, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 1.0),
      child: Padding(
        padding: EdgeInsets.only(left: 8.0,top: 8.0,right: 8.0,bottom: 0.0),
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              headingText,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: onTap,
              child: TextButton(
                onPressed: (){},
                child: Text(
                  buttonText,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

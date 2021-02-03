import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({this.title,this.colour,this.tag,@required this.onPressed});

  final Color colour;
  final String title;
  final Function onPressed;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Hero(
        tag: tag,
        child: Material(
          elevation: 5.0,
          color: colour,
          borderRadius: BorderRadius.circular(30.0),
          child: MaterialButton(
            onPressed: onPressed,
            minWidth: 300.0,
            height: 42.0,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Handlee',
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
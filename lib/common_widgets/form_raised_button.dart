import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timetracker/common_widgets/custom_raised_button.dart';

class FormRaisedButton extends CustomRaisedButton {
  FormRaisedButton({
    @required String text,
    @required VoidCallback onPressed,
  }) : super(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          height: 44.0,
          color: Colors.indigo,
          onPressed: onPressed,
        );
}

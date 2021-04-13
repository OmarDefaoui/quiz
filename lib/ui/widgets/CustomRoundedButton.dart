import 'package:flutter/material.dart';

class CustomRoundedButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  const CustomRoundedButton({
    this.child,
    this.onPressed,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(45.0),
        ),
        primary: Theme.of(context).accentColor,
      ),
      child: child,
      onPressed: onPressed,
    );
  }
}

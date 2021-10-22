import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlueButton extends StatelessWidget {
  final String? title;
  final Widget? child;
  final GestureTapCallback? onPressed;

  const BlueButton({this.title, required this.onPressed, this.child, Key? key})
      : super(key: key);

  static const enableBackgroundColor = BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color(0xFF296AE3),
        Color(0xFF4690EC),
      ],
    ),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  );

  static const disableBackgroundColor = BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Colors.grey,
        Colors.grey,
      ],
    ),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 50,
        child: Center(
          child: child ?? Text(
            title ?? "",
            style: const TextStyle(
                color: Colors.white,
                fontSize: 17.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        decoration: null == onPressed ? disableBackgroundColor : enableBackgroundColor,
      ),
      onTap: onPressed,
    );
  }
}

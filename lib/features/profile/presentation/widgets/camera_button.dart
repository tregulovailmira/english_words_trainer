import 'package:flutter/material.dart';

class CameraButton extends StatelessWidget {
  const CameraButton({
    required this.icon,
    this.alignment = Alignment.bottomLeft,
    Key? key,
  }) : super(key: key);

  final IconData icon;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20,
        ),
        height: 50,
        width: 50,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(2, 2),
              blurRadius: 10,
            )
          ],
        ),
        child: Center(child: Icon(icon)),
      ),
    );
  }
}

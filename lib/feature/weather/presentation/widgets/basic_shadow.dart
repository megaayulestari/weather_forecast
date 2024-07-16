import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BasicShadow extends StatelessWidget {
  const BasicShadow({super.key, required this.topDown});
  final bool topDown;

  //Widget pengaturan shadow tampilan
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: topDown?Alignment.topCenter:Alignment.bottomCenter,
          end: topDown?Alignment.bottomCenter:Alignment.topCenter,
          colors: [
            Colors.black87,
            Colors.transparent,
          
          ],
        ),
      ),
    );
  }
}
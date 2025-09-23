import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10.0, bottom: 45.0),
      alignment: Alignment.center,
      child: const Text(
        '',
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }
}

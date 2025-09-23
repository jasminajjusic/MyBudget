import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyGoals extends StatelessWidget {
  const EmptyGoals({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/icons/no_goals.svg',
            width: 200,
            height: 200,
          ),
          const SizedBox(height: 24),
          const Text(
            'No achieved goals yet',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

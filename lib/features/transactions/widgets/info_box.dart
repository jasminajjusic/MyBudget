import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mybudget/features/transactions/widgets/styles.dart';

class InfoBox extends StatelessWidget {
  final String iconPath;
  final String text;
  final double borderRadius;

  const InfoBox({
    Key? key,
    required this.iconPath,
    required this.text,
    this.borderRadius = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: AppColors.appBarColor,
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.all(4),
              child: SvgPicture.asset(iconPath, color: Colors.white),
            ),
          ),
          Expanded(child: Text(text, style: AppTextStyles.infoText)),
        ],
      ),
    );
  }
}

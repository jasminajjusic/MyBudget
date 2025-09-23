import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:mybudget/features/transactions/widgets/styles.dart';

class IconWithTexts extends StatelessWidget {
  final String iconPath;
  final String category;
  final String transactionType;

  const IconWithTexts({
    Key? key,
    required this.iconPath,
    required this.category,
    required this.transactionType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 64,
          width: 64,
          decoration: BoxDecoration(
            color: AppColors.appBarColor,
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.all(12),
          child: SvgPicture.asset(
            iconPath,
            color: Colors.white,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 120,
          child: Text(
            category,
            style: AppTextStyles.category,
            softWrap: true,
            overflow: TextOverflow.visible,
            maxLines: 1,
          ),
        ),
        SizedBox(
          width: 64,
          child: Text(
            transactionType,
            style: AppTextStyles.transactionType,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

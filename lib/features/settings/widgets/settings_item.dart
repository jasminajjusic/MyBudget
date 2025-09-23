import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsItem extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const SettingsItem({required this.title, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
            SvgPicture.asset(
              'assets/icons/right_arrow.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                Colors.black54,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

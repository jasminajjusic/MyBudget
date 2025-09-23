import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconPicker extends StatelessWidget {
  final ValueNotifier<String?> selectedIconKey;

  IconPicker({super.key, required this.selectedIconKey});

  // Mapa ikonica je sada u klasi, dostupna svugdje
  final Map<String, String> icons = {
    'entertainment_1': 'assets/icons/entertainment_1.svg',
    'entertainment_2': 'assets/icons/entertainment_2.svg',
    'entertainment_3': 'assets/icons/entertainment_3.svg',
    'gym_1': 'assets/icons/gym_1.svg',
    'gym_2': 'assets/icons/gym_2.svg',
    'coffee_1': 'assets/icons/coffee_1.svg',
    'netflix': 'assets/icons/netflix.svg',
    'sport': 'assets/icons/sport.svg',
    'shopping_1': 'assets/icons/shopping_1.svg',
    'movie': 'assets/icons/movie.svg',
    'music': 'assets/icons/music.svg',
    'restaurant': 'assets/icons/restaurant.svg',
    'home': 'assets/icons/home.svg',
    'bills': 'assets/icons/bills.svg',
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final selected = await showModalBottomSheet<String>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder:
              (_) => Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: icons.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final key = icons.keys.elementAt(index);
                    final asset = icons[key]!;
                    return GestureDetector(
                      onTap: () => Navigator.pop(context, key),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SvgPicture.asset(asset),
                      ),
                    );
                  },
                ),
              ),
        );

        if (selected != null) selectedIconKey.value = selected;
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ValueListenableBuilder<String?>(
              valueListenable: selectedIconKey,
              builder:
                  (_, value, __) => Row(
                    children: [
                      if (value != null)
                        SvgPicture.asset(icons[value]!, width: 24, height: 24),
                      const SizedBox(width: 8),
                      Text(value ?? 'Select icon'),
                    ],
                  ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}

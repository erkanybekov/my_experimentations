import 'package:flutter/material.dart';
import 'package:my_experimentations/26-Jun/location_list_item.dart';

class ParallaxRecipe extends StatelessWidget {
  const ParallaxRecipe({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (final location in locations)
            LocationListItem(
              imageUrl: location.imageUrl,
              country: location.place,
              name: location.name,
            ),
        ],
      ),
    );
  }
}

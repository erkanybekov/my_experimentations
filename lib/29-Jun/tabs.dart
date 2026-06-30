import 'package:flutter/material.dart';
import 'package:my_experimentations/26-Jun/parallax_recipe.dart';

class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.directions_car)),
              Tab(icon: Icon(Icons.directions_bike)),
              Tab(icon: Icon(Icons.directions_boat)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: ParallaxRecipe()),
            Center(child: ParallaxRecipe()),
            Center(child: ParallaxRecipe()),
          ],
        ),
      ),
    );
  }
}

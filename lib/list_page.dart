import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final list = <String>[
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
  ];

  @override
  Widget build(BuildContext context) {
    // Best practice: Don't nest MaterialApp if already inside one (ListPage is usually not root)
    // To keep it modular, use Scaffold here (assume MaterialApp is higher up)
    // Must-have rare tips and tricks on Dart lists, demonstrated and explained!
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rare List Tips & Tricks (with Examples)"),
        centerTitle: false,
      ),
      body: ListView(
        key: const PageStorageKey<String>('list_page_listview'),
        children: [
          ListTile(
            tileColor: Colors.pink[50],
            title: const Text("1. Chunking a List"),
            subtitle: const Text(
              '''Chunk a Dart list into smaller lists of a given size:

// Extension:
extension Chunk<T> on List<T> {
  List<List<T>> chunked(int size) =>
    [for (var i = 0; i < length; i += size) sublist(i, (i + size > length) ? length : i + size)];
}

// Example:
final letters = ["A","B","C","D","E","F","G","H","I","J","K","L","M"];
final chunks = letters.chunked(3);
print(chunks); // [[A, B, C], [D, E, F], [G, H, I], [J, K, L], [M]]

''',
              style: TextStyle(fontSize: 12, fontFamily: 'monospace'),
            ),
          ),
          ListTile(
            tileColor: Colors.blue[50],
            title: const Text("2. Remove Where with Index"),
            subtitle: const Text(
              '''Want to filter items by their index?

import 'package:collection/collection.dart';

final list = [10, 20, 30, 40, 50, 60];
// Keep only even indexes:
final result = list.whereIndexed((i, x) => i % 2 == 0).toList();
print(result); // [10, 30, 50]
''',
              style: TextStyle(fontSize: 12, fontFamily: 'monospace'),
            ),
          ),
          ListTile(
            tileColor: Colors.green[50],
            title: const Text("3. Flatten Nested Lists"),
            subtitle: const Text(
              '''Turn a list of lists into a flat list:

final nested = [
  ["A", "B"],
  ["C"],
  ["D", "E"]
];
final flat = nested.expand((e) => e).toList();
print(flat); // [A, B, C, D, E]
''',
              style: TextStyle(fontSize: 12, fontFamily: 'monospace'),
            ),
          ),
          ListTile(
            tileColor: Colors.yellow[50],
            title: const Text("4. Replace all matching elements"),
            subtitle: const Text(
              '''Replace all matching entries in a list:

final list = ["A", "B", "A"];
final replaced = list.map((e) => e == "A" ? "Z" : e).toList();
print(replaced); // [Z, B, Z]
''',
              style: TextStyle(fontSize: 12, fontFamily: 'monospace'),
            ),
          ),
          ListTile(
            tileColor: Colors.orange[50],
            title: const Text("5. Shuffling Only a Portion of a List"),
            subtitle: const Text(
              '''Shuffle just a slice of your list:

import "dart:math";

final list = [1, 2, 3, 4, 5, 6, 7];
final sub = list.sublist(1, 5)..shuffle(Random());
list.setRange(1, 5, sub);

print(list); // e.g. [1, 5, 3, 2, 4, 6, 7] (middle shuffled)
''',
              style: TextStyle(fontSize: 12, fontFamily: 'monospace'),
            ),
          ),
          ListTile(
            tileColor: Colors.purple[50],
            title: const Text("6. Unmodifiable Lists"),
            subtitle: const Text(
              '''Make a list unmodifiable (read-only):

final list = ["A", "B", "C"];
final unmodifiable = List.unmodifiable(list);
unmodifiable[0] = "X"; // Throws UnsupportedError
''',
              style: TextStyle(fontSize: 12, fontFamily: 'monospace'),
            ),
          ),
          ListTile(
            tileColor: Colors.teal[50],
            title: const Text("7. Using generate() for Custom Lists"),
            subtitle: const Text(
              '''Generate a list programmatically:

final list = List.generate(5, (i) => "Item \$i");
print(list); // [Item 0, Item 1, Item 2, Item 3, Item 4]
''',
              style: TextStyle(fontSize: 12, fontFamily: 'monospace'),
            ),
          ),
          ListTile(
            tileColor: Colors.red[50],
            title: const Text("8. Remove Duplicates (Preserve Order)"),
            subtitle: const Text(
              '''Remove duplicates in a list:

final list = ["A", "B", "A", "C", "B"];
// Fast (order not guaranteed):
var unique = list.toSet().toList();
// Preserve order:
var seen = <String>{};
var orderedUnique = list.where((e) => seen.add(e)).toList();

print(orderedUnique); // [A, B, C]
''',
              style: TextStyle(fontSize: 12, fontFamily: 'monospace'),
            ),
          ),
          const Divider(thickness: 2),
          ListTile(
            tileColor: Colors.grey[100],
            title: const Text("Try these tips in your Dart code!"),
            subtitle: Text(
              "Most people only know basic add/remove/list access.\n"
              "Dive into advanced features for power and expressivity!",
              style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

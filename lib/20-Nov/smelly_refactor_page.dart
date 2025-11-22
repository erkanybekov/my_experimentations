// import 'package:flutter/material.dart';

// class ProfilePage extends StatelessWidget {
//   final String name;
//   final String email;

//   const ProfilePage({super.key, required this.name, required this.email});

//   static const _kSpacing = 12.0;
//   static const _kPadding = 16.0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Profile", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
//         centerTitle: false,
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               ProfileCard(name: name, email: email),
//               ..._actionButtons(context),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   List<Widget> _actionButtons(BuildContext context) {
//     final actions = [
//       _ActionButton('Edit Profile', () {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(const SnackBar(content: Text('Edit clicked')));
//       }),
//       _ActionButton('Logout', () {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(const SnackBar(content: Text('Logout clicked')));
//       }),
//     ];

//     return actions
//         .map(
//           (a) => Padding(
//             padding: const EdgeInsets.only(bottom: _kSpacing),
//             child: ElevatedButton(onPressed: a.onPressed, child: Text(a.label)),
//           ),
//         )
//         .toList();
//   }
// }

// class ProfileCard extends StatelessWidget {
//   final String name;
//   final String email;

//   const ProfileCard({super.key, required this.name, required this.email});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: ListTile(
//         contentPadding: const EdgeInsets.all(16),
//         leading: CircleAvatar(
//           radius: 32,
//           backgroundColor: Colors.blue,
//           child: Text(name[0]),
//         ),
//         title: Text(
//           name,
//           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//         ),
//         subtitle: Text(email, style: const TextStyle(color: Colors.grey)),
//       ),
//     );
//   }
// }

// class _ActionButton {
//   final String label;
//   final VoidCallback onPressed;
//   const _ActionButton(this.label, this.onPressed);
// }

import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String name;
  final String email;

  const ProfilePage({super.key, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // profile picture + info
              ProfileCard(name: name, email: email),
              const SizedBox(height: 24),
              // edit profile button
              _editButton(name, Colors.red, () {}),
              const SizedBox(height: 12),
              // logout button
              _editButton(name, Colors.cyan, () {}),
              const SizedBox(height: 12),
              // some extra info for no reason
              ExtraInfo(),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _editButton(String name, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: color),
        onPressed: onPressed,
        child: Text(name),
      ),
    );
  }
}

class ExtraInfo extends StatelessWidget {
  const ExtraInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.grey.shade200,
      child: const Text('Member since 2023'),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final String name;
  final String email;

  const ProfileCard({super.key, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: CircleAvatar(
          radius: 32,
          backgroundColor: Colors.blue,
          child: Text(name[0]),
        ),
        title: Text(name),
        subtitle: Text(email),
      )
    );
  }
}

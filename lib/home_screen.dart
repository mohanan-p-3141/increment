import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_increament_app/login_screen.dart';
import 'database_helper.dart';

class HomeScreen extends ConsumerWidget {
  final String username;

  HomeScreen({required this.username});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(userProvider(username));
    final userNotifier = ref.read(userProvider(username).notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Value: $value', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: userNotifier.increment,
              child: Text('Increment'),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:user_increament_app/login_screen.dart';
import 'database_helper.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  HomeScreen({required this.username});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _value = 0;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadValue();
  }

  Future<void> _loadValue() async {
    final user = await _dbHelper.getUser(widget.username);
    setState(() {
      _value = user?['value'] ?? 0;
    });
  }

  Future<void> _incrementValue() async {
    setState(() {
      _value++;
    });
    await _dbHelper.updateUserValue(widget.username, _value);
  }
  void _logout() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => LoginScreen(),));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Value: $_value', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _incrementValue,
              child: Text('Increment'),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:bus_season_ticker_users/userPages/bothUsers/DataProvider.dart';
import 'package:bus_season_ticker_users/userPages/bothUsers/Home.dart';
import 'package:bus_season_ticker_users/userPages/bothUsers/MyAccount.dart';
import 'package:bus_season_ticker_users/userPages/bothUsers/RenewSeasonTicket.dart';
import 'package:flutter/material.dart';

class bottomNavigationBarStu extends StatefulWidget {
  final String token;
  final String userId;
  final String role;

  const bottomNavigationBarStu({
    Key? key,
    required this.token,
    required this.userId,
    required this.role,
  }) : super(key: key);

  @override
  State<bottomNavigationBarStu> createState() => _bottomNavigationBarStuState();
}

class _bottomNavigationBarStuState extends State<bottomNavigationBarStu> {
  int _currentIndex = 0;
  late List<Widget> _tabs;
  bool _isExecuting = false;

  @override
  void initState() {
    super.initState();

    _tabs = [
      Home(token: widget.token, userId: widget.userId, role: widget.role),
      RenewSeasonTicket(token: widget.token, userId: widget.userId),
      MyAccount(token: widget.token, userId: widget.userId, role: widget.role)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (!_isExecuting) {
            // Only allow navigation if not currently executing
            setState(() {
              _currentIndex = index;
            });
            // help to make delayed
            _simulateAsyncTask();
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_moderator_rounded),
            label: 'Ticket',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'My Account',
          )
        ],
      ),
    );
  }

  void _simulateAsyncTask() async {
    setState(() {
      _isExecuting = true;
    });

    // Simulate an asynchronous task
    await Future.delayed(Duration(seconds: 4));

    setState(() {
      _isExecuting = false;
    });
  }
}

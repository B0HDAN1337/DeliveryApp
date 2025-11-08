import 'package:delivery_app/pages/account_page.dart';
import 'package:delivery_app/pages/home_page.dart';
import 'package:delivery_app/pages/usermain_page.dart';
import 'package:flutter/material.dart';

class UserNavigation extends StatefulWidget {
  const UserNavigation({super.key});

  @override
  State<UserNavigation> createState() => _NavigationState();
}

class _NavigationState extends State<UserNavigation> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final List<Widget> pages = const [
      UserMainPage(),
      AccountPage(),
    ];

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const[
          NavigationDestination(
            icon: Badge(child: Icon(Icons.home)),
            label: 'second',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.account_box)),
            label: 'Account',
          ),
        ],
      ),
      body: pages [currentPageIndex],
    );
  }
}
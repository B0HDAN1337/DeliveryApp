import 'package:delivery_app/pages/account_page.dart';
import 'package:delivery_app/pages/availableOrders_page.dart';
import 'package:delivery_app/pages/home_page.dart';
import 'package:delivery_app/pages/orders_page.dart';
import 'package:delivery_app/pages/usermain_page.dart';
import 'package:flutter/material.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final List<Widget> pages = const [
      HomePage(),
      OrdersPage(),
      AvailableOrdersPage(),
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
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.home)),
            label: 'My Orders',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.abc_outlined)), 
            label: 'Orders'
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
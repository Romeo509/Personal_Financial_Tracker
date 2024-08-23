import 'package:flutter/material.dart';
import 'package:frontend/mainPages/AccountPage.dart';
import 'package:frontend/mainPages/HomePage.dart';
import 'package:frontend/mainPages/transactionsPage.dart';
import 'package:frontend/mainPages/upcomingTransactionsPage.dart';


class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _currentIndex = 0;

  setCurrentPage( int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        const HomePage(),
        const TransactionPage(),
        const PastTransactionsPage(),
        const AccountPage(),
      ][_currentIndex],
      bottomNavigationBar: navigationBar(),
    );
  }
  Widget navigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      unselectedItemColor: Colors.grey,
      selectedItemColor: Colors.greenAccent,
      currentIndex: _currentIndex,
      onTap: (index) => setCurrentPage(index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.money), label: "Upcoming"),
        BottomNavigationBarItem(
            icon: Icon(Icons.credit_card), label: "Past"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
      ],
    );
  }
}

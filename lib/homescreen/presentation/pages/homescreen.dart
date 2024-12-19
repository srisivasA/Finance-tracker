import 'package:Expanses/core/colors.dart';
import 'package:flutter/material.dart';

import 'Home_tab.dart';
import 'add_transaction_screen.dart';
import 'report_tab.dart';
import 'transactions_tab.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // Current tab index

  final List<Widget> _tabs = [
    HomeTab(),       
    TransactionsTab(),  
    ReportTab(),        
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finance Tracker'),
        backgroundColor: AppColors.incomeColor, 
      ),
      body: _tabs[_currentIndex], 

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.incomeColor,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddTransactionScreen()),
          );
        },
        tooltip: 'Add Transaction',
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: AppColors.incomeColor, 
        unselectedItemColor: AppColors.unselectedTabColor, 
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_sharp),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Report',
          ),
        ],
      ),
    );
  }
}

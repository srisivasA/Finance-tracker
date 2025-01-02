import 'dart:io';

import 'package:Expanses/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../profileScreen/presentation/profileScreen.dart';
import '../../../profileScreen/provider/profile_provider.dart';
import '../../../reportTab/presentation/report_tab.dart';
import 'Home_tab.dart';
import 'add_transaction_screen.dart';
import 'transactions_tab.dart';

class HomeScreen extends ConsumerStatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0; 

  final List<Widget> _tabs = [
    HomeTab(),       
    TransactionsTab(), 
    ReportTab(),      
  ];

  @override
  Widget build(BuildContext context) {
  
    final profileImagePath = ref.watch(profileImageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Tracker'),
        backgroundColor: AppColors.incomeColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
               
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
              child: CircleAvatar(
                backgroundImage: profileImagePath != null &&
                        File(profileImagePath).existsSync()
                    ? FileImage(File(profileImagePath))
                    : const AssetImage('assets/images/profile.png') as ImageProvider,
                radius: 20.0, 
                child: profileImagePath == null
                    ? const Icon(Icons.person, size: 20, color: Colors.white)
                    : null,
              ),
            ),
          ),
        ],
      ),
      body: _tabs[_currentIndex], 

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.incomeColor,
        child: const Icon(Icons.add),
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

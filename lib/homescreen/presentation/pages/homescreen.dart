import 'dart:io';

import 'package:Expanses/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../profileScreen/presentation/profileScreen.dart';
import '../../../profileScreen/provider/profile_provider.dart';
import 'Home_tab.dart';
import 'add_transaction_screen.dart';
import 'report_tab.dart';
import 'transactions_tab.dart';

class HomeScreen extends ConsumerStatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0; // Current tab index

  final List<Widget> _tabs = [
    HomeTab(),       // Home tab screen
    TransactionsTab(), // Transactions tab screen
    ReportTab(),       // Report tab screen
  ];

  @override
  Widget build(BuildContext context) {
    // Watch the profile image path state from Riverpod provider.
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
                // Navigate to ProfileScreen to update the profile image.
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
                radius: 20.0, // Adjusted size for the AppBar
                child: profileImagePath == null
                    ? const Icon(Icons.person, size: 20, color: Colors.white)
                    : null,
              ),
            ),
          ),
        ],
      ),
      body: _tabs[_currentIndex], // Display the current tab

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

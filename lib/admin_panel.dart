import 'package:battlegrands_admin/Admin_Home.dart';
import 'package:battlegrands_admin/admin_tournament.dart';
import 'package:battlegrands_admin/withdrawal_request.dart';
import 'package:flutter/material.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('A D M I N'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home), text: 'Home'),
              Tab(icon: Icon(Icons.gamepad_outlined), text: 'Tournaments'),
              Tab(icon: Icon(Icons.attach_money_outlined), text: 'Withdrawals'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AdminHome(),
            AdminTournament(),
            WithdrawalRequest(),
          ],
        ),
      ),
    );
  }
}

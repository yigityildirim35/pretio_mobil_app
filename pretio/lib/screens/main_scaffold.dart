import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import 'dashboard_page.dart';
import 'analytics_page.dart';
import 'goals_page.dart';

import 'budget_page.dart';
import 'profile_page.dart';
import '../providers/transaction_provider.dart';
import '../providers/navigation_provider.dart';
import '../widgets/settings_drawer.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);

    return Scaffold(
      drawer: const SettingsDrawer(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: Consumer<NavigationProvider>(
          builder: (context, navProvider, child) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: IndexedStack(
                    index: navProvider.selectedIndex,
                    children: [
                      // 0. Dashboard
                      const DashboardPage(),
                      // 1. Analytics
                      const AnalyticsPage(),
                      // 2. Goals
                      const GoalsPage(),
                      // 3. BUDGET PAGE (Time + Shadow Birleşimi)
                      const BudgetPage(),
                      // 4. Profile
                      ProfilePage(
                        salary: provider.salary,
                        weeklyHours: provider.weeklyHours,
                        onSalaryChanged: (val) {
                          provider.updateSalaryAndHours(
                            val,
                            provider.weeklyHours,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: CustomBottomNavBar(
                    selectedIndex: navProvider.selectedIndex,
                    onTap: navProvider.setIndex,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

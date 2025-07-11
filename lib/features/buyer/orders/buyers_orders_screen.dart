import 'package:flutter/material.dart';
import 'package:popcart/core/widgets/widgets.dart';
import 'package:popcart/features/seller/orders/orders_tab.dart';

class BuyersOrdersScreen extends StatefulWidget {
  const BuyersOrdersScreen({super.key});

  @override
  State<BuyersOrdersScreen> createState() => _BuyersOrdersScreenState();
}

class _BuyersOrdersScreenState extends State<BuyersOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  final tabs = ['All', 'In Progress', 'Delivered'];

  void _onTabTap(int index) {
    setState(() => _selectedIndex = index);
    _tabController.animateTo(index,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  @override
  void initState() {
    _tabController = TabController(length: tabs.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              CustomTabBar(
                tabs: tabs,
                selectedIndex: _selectedIndex,
                onTap: _onTabTap,
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children:
                      tabs.map((type) => OrdersTabView(type: type)).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

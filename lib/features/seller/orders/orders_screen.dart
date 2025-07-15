import 'package:flutter/material.dart';
import 'package:popcart/core/widgets/widgets.dart';
import 'package:popcart/features/seller/orders/seller_orders_tab.dart';

class SellerOrdersScreen extends StatefulWidget {
  const SellerOrdersScreen({super.key});

  @override
  State<SellerOrdersScreen> createState() => _SellerOrdersScreenState();
}

class _SellerOrdersScreenState extends State<SellerOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  final tabs = ['All', 'Pending', 'Processing'];

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
      appBar: AppBar(
        title: const Text('Orders'),
        automaticallyImplyLeading: false,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
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
                    tabs.map((type) => SellerOrdersTabView(type: type)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

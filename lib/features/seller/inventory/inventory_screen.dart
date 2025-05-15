import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:popcart/app/router_paths.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/widgets/buttons.dart';
import 'package:popcart/core/widgets/widgets.dart';
import 'package:popcart/features/seller/inventory/inventory_tab.dart';
import 'package:popcart/gen/assets.gen.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  final tabs = ['All', 'Low stock', 'Out of stock'];

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
        title: const Text('Inventory'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {

            },
            icon: AppAssets.icons.chat.themedIcon(context),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: CustomElevatedButton(
          onPressed: () {
            context.pushNamed(
              AppPath.authorizedUser.seller.inventory.addProduct.path,
            );
          },
          text: 'Add Product',
          icon: Icons.add,
        ),
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
                    tabs.map((type) => ProductTabView(type: type)).toList(),
              ),
            ),
            // SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 50,),
          ],
        ),
      ),
    );
  }
}

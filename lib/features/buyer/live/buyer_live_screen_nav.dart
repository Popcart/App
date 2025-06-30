import 'package:flutter/material.dart';
import 'package:popcart/core/widgets/widgets.dart';
import 'package:popcart/features/buyer/live/live_rooms.dart';
import 'package:popcart/features/buyer/live/scheduled_rooms.dart';

class BuyerLiveScreenNav extends StatefulWidget {
  const BuyerLiveScreenNav({super.key});

  @override
  State<BuyerLiveScreenNav> createState() => _BuyerLiveScreenNavState();
}

class _BuyerLiveScreenNavState extends State<BuyerLiveScreenNav>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  final tabs = [
    'Live Rooms',
    'Upcoming',
  ];

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
        title: const Text('Live'),
        automaticallyImplyLeading: false,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
        padding: const EdgeInsets.all(20),
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
                  children: const [LiveRooms(), ScheduledRooms()]),
            ),
          ],
        ),
      ),
    );
  }
}

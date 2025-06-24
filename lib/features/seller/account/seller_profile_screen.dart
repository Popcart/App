import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:popcart/app/app.module.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/widgets/buttons.dart';
import 'package:popcart/core/widgets/widgets.dart';
import 'package:popcart/gen/assets.gen.dart';
import 'package:popcart/route/route_constants.dart';

class SellerProfileScreen extends StatefulWidget {
  const SellerProfileScreen({super.key});

  @override
  State<SellerProfileScreen> createState() => _SellerProfileScreenState();
}

class _SellerProfileScreenState extends State<SellerProfileScreen>
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
        title: const Text('Account'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, sellerSettings);
            },
            icon: AppAssets.icons.gear.themedIcon(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Row(
              children: [
                CircleAvatar(
                  radius: 36,
                ),
                SizedBox(width: 20),
                Column(
                  children: [
                    Text(
                      'John Doe',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '2 followings',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xff111214),
                fixedSize: const Size(double.infinity, 48),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                side: const BorderSide(
                  color: AppColors.orange,
                ),
              ),
              child: const Text(
                'View Profile',
                style: TextStyle(
                  color: AppColors.orange,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TabBar(
              tabs: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  AppAssets.icons.play.svg(),
                  const SizedBox(width: 15,),
                  const Text('Pop-play', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15))
                ],),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  AppAssets.icons.profile.svg(),
                  const SizedBox(width: 15,),
                  const Text('Account', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),)
                ],)
              ],
              labelPadding: const EdgeInsets.only(bottom: 10),
              indicatorColor: AppColors.white,
              dividerColor: Colors.transparent,
              labelColor: AppColors.white,
              controller: _tabController,
              onTap: _onTabTap,
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    const SingleChildScrollView(
                        child: SizedBox()),
                    SingleChildScrollView(
                      child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      shrinkWrap: true,
                      childAspectRatio: 1.2,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _actionCard(
                          title: 'Messages',
                          icon: AppAssets.icons.messages.svg(),
                          onTap: () {},
                        ),
                        _actionCard(
                          title: 'Purchases',
                          icon: AppAssets.icons.purchases.svg(),
                          onTap: () {},
                        ),
                        _actionCard(
                          title: 'Boosts',
                          icon: AppAssets.icons.boosts.svg(),
                          onTap: () {},
                        ),
                        _actionCard(
                          title: 'Rewards',
                          icon: AppAssets.icons.rewards.svg(),
                          onTap: () {},
                        ),
                        _actionCard(
                          title: 'Bookmarks',
                          icon: AppAssets.icons.bookmark.svg(),
                          onTap: () {},
                        ),
                        _actionCard(
                          title: 'Interests',
                          icon: AppAssets.icons.interests.svg(),
                          onTap: () {},
                        ),
                      ],
                                      ),
                    ),]
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionCard({
    required String title,
    required Widget icon,
    required void Function() onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff24262b),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xff111214).withOpacity(0.45),
            radius: 24,
            child: icon,
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

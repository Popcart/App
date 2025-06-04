import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:popcart/app/app.module.dart';
import 'package:popcart/app/shared_prefs.dart';
import 'package:popcart/app/theme_cubit.dart';
import 'package:popcart/gen/assets.gen.dart';

class BuyerSetingsScreen extends StatelessWidget {
  const BuyerSetingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xff24262b),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  _settingTile(
                    leading: AppAssets.icons.personalInformation.svg(),
                    title: 'Personal Information',
                    onTap: () {},
                    color: const Color(0xff279af3),
                  ),
                  _settingTile(
                    leading: AppAssets.icons.paymentMethods.svg(),
                    title: 'Payment Methods',
                    onTap: () {},
                    color: const Color(0xff6fd299),
                  ),
                  _settingTile(
                    leading: AppAssets.icons.addressBook.svg(),
                    title: 'Address Book',
                    onTap: () {},
                    color: const Color(0xfffe724e),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Preferences',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xff24262b),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  _settingTile(
                    leading: AppAssets.icons.findFriends.svg(),
                    title: 'Find Friends',
                    onTap: () {},
                    color: const Color(0xff8E94f2),
                  ),
                  _settingTile(
                    leading: AppAssets.icons.notifications.svg(),
                    title: 'Notifications',
                    onTap: () {},
                    color: const Color(0xffe0928e),
                  ),
                  _settingTile(
                    leading: AppAssets.icons.becomeASeller.svg(),
                    title: 'Become a seller',
                    onTap: () {},
                    color: const Color(0xff148ab0),
                  ),
                  _settingTile(
                    leading: AppAssets.icons.deleteAccount.svg(),
                    title: 'Delete account',
                    onTap: () {},
                    color: const Color(0xfffdbc3c),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    visualDensity:
                        const VisualDensity(horizontal: -4, vertical: -4),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xfffdbc3c),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: AppAssets.icons.deleteAccount.svg(),
                    ),
                    title: Text(
                      'Switch app theme',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: Switch(
                      value: context.watch<ThemeCubit>().state == ThemeMode.dark,
                      onChanged: (val) {
                        context.read<ThemeCubit>().toggleTheme(val);
                      },
                    )
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xff24262b),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  _settingTile(
                    leading: AppAssets.icons.logOut.svg(),
                    title: 'Log out',
                    onTap: () {
                      locator<SharedPrefs>().loggedIn = false;
                      context.pushReplacement(AppPath.auth.path);
                    },
                    color: const Color(0xffcc0000),
                    textColor: const Color(0xffcc0000),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingTile({
    required Widget leading,
    required String title,
    required Color color,
    required void Function() onTap,
    Color? textColor,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: leading,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.white,
      ),
    );
  }
}

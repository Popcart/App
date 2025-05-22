import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:popcart/core/colors.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'WorkSans',
).copyWith(
  canvasColor: AppColors.white,
  scaffoldBackgroundColor: AppColors.white,
  progressIndicatorTheme:
      const ProgressIndicatorThemeData(color: AppColors.white),
  bottomAppBarTheme: const BottomAppBarTheme(color: AppColors.white),
  textSelectionTheme:
      const TextSelectionThemeData(cursorColor: AppColors.orange),
  radioTheme:
      RadioThemeData(fillColor: WidgetStateProperty.all(AppColors.orange)),
  cupertinoOverrideTheme: const CupertinoThemeData(
    textTheme: CupertinoTextThemeData(
      textStyle: TextStyle(
        color: AppColors.white,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    showDragHandle: true,
    dragHandleColor: Color(0xff393C43),
    backgroundColor: Color(0xff111214),
  ),
  listTileTheme: const ListTileThemeData(
    contentPadding: EdgeInsets.zero,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    selectedTileColor: AppColors.orange,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.orange,
    foregroundColor: AppColors.appBackground,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      fixedSize: const Size(double.infinity, 56),
    ),
  ),
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    surfaceTintColor: AppColors.white,
    iconTheme: IconThemeData(color: AppColors.black),
    backgroundColor: AppColors.white,
    elevation: 0.1,
    shadowColor: AppColors.white,
    actionsIconTheme: IconThemeData(color: AppColors.black),
    titleTextStyle: TextStyle(
      color: AppColors.black,
      fontSize: 21,
      fontWeight: FontWeight.w700,
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.appBackground,
      unselectedItemColor: AppColors.darkGrey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
          color: AppColors.appBackground),
      unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w400, fontSize: 12, color: AppColors.darkGrey),
      selectedIconTheme: IconThemeData(
        color: AppColors.appBackground,
      ),
      unselectedIconTheme: IconThemeData(
        color: AppColors.darkGrey,
      )),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'WorkSans',
).copyWith(
  canvasColor: AppColors.textFieldFillColor,
  scaffoldBackgroundColor: AppColors.appBackground,
  progressIndicatorTheme:
      const ProgressIndicatorThemeData(color: AppColors.white),
  bottomAppBarTheme: const BottomAppBarTheme(color: AppColors.appBackground),
  textSelectionTheme:
      const TextSelectionThemeData(cursorColor: AppColors.orange),
  radioTheme:
      RadioThemeData(fillColor: WidgetStateProperty.all(AppColors.orange)),
  bottomSheetTheme: const BottomSheetThemeData(
    showDragHandle: true,
    dragHandleColor: Color(0xff393C43),
    backgroundColor: Color(0xff111214),
  ),
  cupertinoOverrideTheme: const CupertinoThemeData(
    textTheme: CupertinoTextThemeData(
      textStyle: TextStyle(
        color: AppColors.white,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
  ),
  listTileTheme: const ListTileThemeData(
    contentPadding: EdgeInsets.zero,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    selectedTileColor: AppColors.orange,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.orange,
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      fixedSize: const Size(double.infinity, 56),
    ),
  ),
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    surfaceTintColor: Color(0xff111214),
    iconTheme: IconThemeData(color: Colors.white),
    backgroundColor: Color(0xff111214),
    elevation: 0.1,
    actionsIconTheme: IconThemeData(color: AppColors.white),
    shadowColor: Color(0xff091824),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 21,
      fontWeight: FontWeight.w700,
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.appBackground,
      selectedItemColor: AppColors.white,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w600, fontSize: 12, color: AppColors.white),
      unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w400, fontSize: 12, color: AppColors.grey),
      selectedIconTheme: IconThemeData(
        color: AppColors.white,
      ),
      unselectedIconTheme: IconThemeData(
        color: AppColors.grey,
      )),
);

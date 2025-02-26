import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'arb/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en')
  ];

  /// No description provided for @get_started.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get get_started;

  /// No description provided for @get_started_sub.
  ///
  /// In en, this message translates to:
  /// **'By signing up you agree to the Popcart terms of service and other privacy policy details'**
  String get get_started_sub;

  /// No description provided for @enter_your_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enter_your_phone_number;

  /// No description provided for @enter_your_phone_number_sub.
  ///
  /// In en, this message translates to:
  /// **'We will send you a verification code'**
  String get enter_your_phone_number_sub;

  /// No description provided for @select_your_account_type.
  ///
  /// In en, this message translates to:
  /// **'Select your account type'**
  String get select_your_account_type;

  /// No description provided for @buyer.
  ///
  /// In en, this message translates to:
  /// **'Buyer'**
  String get buyer;

  /// No description provided for @buyer_sub.
  ///
  /// In en, this message translates to:
  /// **'Find and purchase products'**
  String get buyer_sub;

  /// No description provided for @seller.
  ///
  /// In en, this message translates to:
  /// **'Seller'**
  String get seller;

  /// No description provided for @seller_sub.
  ///
  /// In en, this message translates to:
  /// **'List and sell Your products with ease'**
  String get seller_sub;

  /// No description provided for @are_you_a_registered_business.
  ///
  /// In en, this message translates to:
  /// **'Are you a registered business?'**
  String get are_you_a_registered_business;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @proceed.
  ///
  /// In en, this message translates to:
  /// **'Proceed'**
  String get proceed;

  /// No description provided for @input_the_otp_code.
  ///
  /// In en, this message translates to:
  /// **'Input the OTP code'**
  String get input_the_otp_code;

  /// No description provided for @otp_code_sub.
  ///
  /// In en, this message translates to:
  /// **'We sent an Otp code to your phone number'**
  String get otp_code_sub;

  /// No description provided for @choose_a_username.
  ///
  /// In en, this message translates to:
  /// **'Choose a username'**
  String get choose_a_username;

  /// No description provided for @choose_a_username_sub.
  ///
  /// In en, this message translates to:
  /// **'This will be displayed to other Popcart users'**
  String get choose_a_username_sub;

  /// No description provided for @your_details.
  ///
  /// In en, this message translates to:
  /// **'Your details'**
  String get your_details;

  /// No description provided for @your_details_sub.
  ///
  /// In en, this message translates to:
  /// **'We just need a few more details to set up your account. This information is private and cannot be seen by others on Popcart'**
  String get your_details_sub;

  /// No description provided for @business_details.
  ///
  /// In en, this message translates to:
  /// **'Business details'**
  String get business_details;

  /// No description provided for @business_details_sub.
  ///
  /// In en, this message translates to:
  /// **'We just need a few more details to set up your account. This information is private and cannot be seen by others on Popcart'**
  String get business_details_sub;

  /// No description provided for @select_interests.
  ///
  /// In en, this message translates to:
  /// **'Select interests'**
  String get select_interests;

  /// No description provided for @already_have_an_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get already_have_an_account;

  /// No description provided for @sign_in.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get sign_in;

  /// No description provided for @start_a_livestream.
  ///
  /// In en, this message translates to:
  /// **'Start a livestream'**
  String get start_a_livestream;

  /// No description provided for @livestream_title.
  ///
  /// In en, this message translates to:
  /// **'Livestream title'**
  String get livestream_title;

  /// No description provided for @schedule_livestream.
  ///
  /// In en, this message translates to:
  /// **'Schedule livestream'**
  String get schedule_livestream;

  /// No description provided for @go_live.
  ///
  /// In en, this message translates to:
  /// **'Go live'**
  String get go_live;

  /// No description provided for @start_time.
  ///
  /// In en, this message translates to:
  /// **'Start time'**
  String get start_time;

  /// No description provided for @select_start_time.
  ///
  /// In en, this message translates to:
  /// **'Select start time'**
  String get select_start_time;

  /// No description provided for @select_products.
  ///
  /// In en, this message translates to:
  /// **'Select products'**
  String get select_products;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}

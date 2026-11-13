import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'My budget'**
  String get appTitle;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose language'**
  String get chooseLanguage;

  /// No description provided for @todayAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available today'**
  String get todayAvailable;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get addExpense;

  /// No description provided for @allUnderControl.
  ///
  /// In en, this message translates to:
  /// **'Everything is under control'**
  String get allUnderControl;

  /// No description provided for @todayLimitLabel.
  ///
  /// In en, this message translates to:
  /// **'From daily limit'**
  String get todayLimitLabel;

  /// No description provided for @spentTodayLabel.
  ///
  /// In en, this message translates to:
  /// **'Spent today'**
  String get spentTodayLabel;

  /// No description provided for @dayCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{{count} days} one{{count} day} other{{count} days}}'**
  String dayCount(num count);

  /// No description provided for @balanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Total remaining'**
  String get balanceLabel;

  /// No description provided for @daysLeftLabel.
  ///
  /// In en, this message translates to:
  /// **'Until payday'**
  String get daysLeftLabel;

  /// No description provided for @expenseTitle.
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get expenseTitle;

  /// No description provided for @amountHint.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amountHint;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @insufficientFunds.
  ///
  /// In en, this message translates to:
  /// **'Not enough funds in the total balance'**
  String get insufficientFunds;

  /// No description provided for @dayFinished.
  ///
  /// In en, this message translates to:
  /// **'Day finished'**
  String get dayFinished;

  /// No description provided for @remainingForDate.
  ///
  /// In en, this message translates to:
  /// **'Remaining for {date}: {amount}'**
  String remainingForDate(Object amount, Object date);

  /// No description provided for @carryover.
  ///
  /// In en, this message translates to:
  /// **'Carry the remainder to tomorrow'**
  String get carryover;

  /// No description provided for @redistribute.
  ///
  /// In en, this message translates to:
  /// **'Redistribute across the remaining days'**
  String get redistribute;

  /// No description provided for @periodCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Hooray! The budget period is complete!'**
  String get periodCompletedTitle;

  /// No description provided for @hooray.
  ///
  /// In en, this message translates to:
  /// **'Hooray!'**
  String get hooray;

  /// No description provided for @congratulations.
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get congratulations;

  /// No description provided for @finalAnimationPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'The final raccoon animation will be here.'**
  String get finalAnimationPlaceholder;

  /// No description provided for @setNewBudget.
  ///
  /// In en, this message translates to:
  /// **'Set a new budget'**
  String get setNewBudget;

  /// No description provided for @newBudget.
  ///
  /// In en, this message translates to:
  /// **'New budget'**
  String get newBudget;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total amount'**
  String get totalAmount;

  /// No description provided for @chooseLastDay.
  ///
  /// In en, this message translates to:
  /// **'Choose the last day of the budget'**
  String get chooseLastDay;

  /// No description provided for @period.
  ///
  /// In en, this message translates to:
  /// **'Period: {start} — {end}'**
  String period(Object end, Object start);

  /// No description provided for @enterPositiveAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount greater than zero'**
  String get enterPositiveAmount;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get saving;

  /// No description provided for @saveBudget.
  ///
  /// In en, this message translates to:
  /// **'Save budget'**
  String get saveBudget;

  /// No description provided for @budgetDepletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Budget depleted'**
  String get budgetDepletedTitle;

  /// No description provided for @budgetDepletedBody.
  ///
  /// In en, this message translates to:
  /// **'The current budget has been fully spent. Create a new budget to continue.'**
  String get budgetDepletedBody;

  /// No description provided for @createNewBudget.
  ///
  /// In en, this message translates to:
  /// **'Create a new budget'**
  String get createNewBudget;

  /// No description provided for @languageTooltip.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTooltip;

  /// No description provided for @riveLoadError.
  ///
  /// In en, this message translates to:
  /// **'Rive loading error:\n{error}'**
  String riveLoadError(Object error);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

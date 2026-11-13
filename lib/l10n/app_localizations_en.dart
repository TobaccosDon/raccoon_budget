// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'My budget';

  @override
  String get chooseLanguage => 'Choose language';

  @override
  String get todayAvailable => 'Available today';

  @override
  String get addExpense => 'Add expense';

  @override
  String get allUnderControl => 'Everything is under control';

  @override
  String get todayLimitLabel => 'From daily limit';

  @override
  String get spentTodayLabel => 'Spent today';

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '$count day',
      zero: '$count days',
    );
    return '$_temp0';
  }

  @override
  String get balanceLabel => 'Total remaining';

  @override
  String get daysLeftLabel => 'Until payday';

  @override
  String get expenseTitle => 'Add expense';

  @override
  String get amountHint => 'Amount';

  @override
  String get cancel => 'Cancel';

  @override
  String get add => 'Add';

  @override
  String get insufficientFunds => 'Not enough funds in the total balance';

  @override
  String get dayFinished => 'Day finished';

  @override
  String remainingForDate(Object amount, Object date) {
    return 'Remaining for $date: $amount';
  }

  @override
  String get carryover => 'Carry the remainder to tomorrow';

  @override
  String get redistribute => 'Redistribute across the remaining days';

  @override
  String get periodCompletedTitle => 'Hooray! The budget period is complete!';

  @override
  String get hooray => 'Hooray!';

  @override
  String get congratulations => 'Congratulations!';

  @override
  String get finalAnimationPlaceholder =>
      'The final raccoon animation will be here.';

  @override
  String get setNewBudget => 'Set a new budget';

  @override
  String get newBudget => 'New budget';

  @override
  String get totalAmount => 'Total amount';

  @override
  String get chooseLastDay => 'Choose the last day of the budget';

  @override
  String period(Object end, Object start) {
    return 'Period: $start — $end';
  }

  @override
  String get enterPositiveAmount => 'Enter an amount greater than zero';

  @override
  String get saving => 'Saving…';

  @override
  String get saveBudget => 'Save budget';

  @override
  String get budgetDepletedTitle => 'Budget depleted';

  @override
  String get budgetDepletedBody =>
      'The current budget has been fully spent. Create a new budget to continue.';

  @override
  String get createNewBudget => 'Create a new budget';

  @override
  String get languageTooltip => 'Language';

  @override
  String riveLoadError(Object error) {
    return 'Rive loading error:\n$error';
  }
}

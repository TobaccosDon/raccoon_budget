// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Мой бюджет';

  @override
  String get chooseLanguage => 'Выберите язык';

  @override
  String get todayAvailable => 'Можно потратить сегодня';

  @override
  String get addExpense => 'Добавить расход';

  @override
  String get allUnderControl => 'Всё под контролем';

  @override
  String get todayLimitLabel => 'Из дневного лимита';

  @override
  String get spentTodayLabel => 'Сегодня потрачено';

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дней',
      many: '$count дней',
      few: '$count дня',
      one: '$count день',
      zero: '$count дней',
    );
    return '$_temp0';
  }

  @override
  String get balanceLabel => 'Осталось всего';

  @override
  String get daysLeftLabel => 'До зарплаты';

  @override
  String get expenseTitle => 'Добавить расход';

  @override
  String get amountHint => 'Сумма';

  @override
  String get cancel => 'Отмена';

  @override
  String get add => 'Добавить';

  @override
  String get insufficientFunds => 'Недостаточно средств в общем остатке';

  @override
  String get dayFinished => 'День завершён';

  @override
  String remainingForDate(Object amount, Object date) {
    return 'Остаток за $date: $amount';
  }

  @override
  String get carryover => 'Перенести остаток на завтра';

  @override
  String get redistribute => 'Перераспределить на оставшиеся дни';

  @override
  String get periodCompletedTitle => 'Ура! Бюджетный период завершён!';

  @override
  String get hooray => 'Ура!';

  @override
  String get congratulations => 'Поздравляем!';

  @override
  String get finalAnimationPlaceholder =>
      'Здесь будет финальная анимация енота.';

  @override
  String get setNewBudget => 'Установить новый бюджет';

  @override
  String get newBudget => 'Новый бюджет';

  @override
  String get totalAmount => 'Общая сумма';

  @override
  String get chooseLastDay => 'Выберите последний день бюджета';

  @override
  String period(Object end, Object start) {
    return 'Период: $start — $end';
  }

  @override
  String get enterPositiveAmount => 'Введите сумму больше нуля';

  @override
  String get saving => 'Сохранение…';

  @override
  String get saveBudget => 'Сохранить бюджет';

  @override
  String get budgetDepletedTitle => 'Бюджет закончился';

  @override
  String get budgetDepletedBody =>
      'Средства текущего бюджета полностью потрачены. Составьте новый бюджет, чтобы продолжить.';

  @override
  String get createNewBudget => 'Составить новый бюджет';

  @override
  String get languageTooltip => 'Язык';

  @override
  String riveLoadError(Object error) {
    return 'Ошибка загрузки Rive:\n$error';
  }
}

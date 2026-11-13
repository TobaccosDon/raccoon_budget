import 'package:flutter/widgets.dart';

class UiTexts {
  UiTexts._(this.languageCode);

  final String languageCode;

  static UiTexts of(BuildContext context) =>
      UiTexts._(Localizations.localeOf(context).languageCode);

  bool get isRu => languageCode == 'ru';
  bool get isEs => languageCode == 'es';

  String get addExpense => isRu ? 'Добавить расход' : isEs ? 'Añadir gasto' : 'Add expense';
  String get amount => isRu ? 'Сумма' : isEs ? 'Importe' : 'Amount';
  String get cancel => isRu ? 'Отмена' : isEs ? 'Cancelar' : 'Cancel';
  String get add => isRu ? 'Добавить' : isEs ? 'Añadir' : 'Add';
  String get newBudget => isRu ? 'Новый бюджет' : isEs ? 'Nuevo presupuesto' : 'New budget';
  String get totalAmount => isRu ? 'Общая сумма' : isEs ? 'Importe total' : 'Total amount';
  String get chooseLastDay => isRu ? 'Выберите последний день бюджета' : isEs ? 'Elige el último día del presupuesto' : 'Choose the last day of the budget';
  String get enterPositiveAmount => isRu ? 'Введите сумму больше нуля' : isEs ? 'Introduce una cantidad mayor que cero' : 'Enter an amount greater than zero';
  String get saveBudget => isRu ? 'Сохранить бюджет' : isEs ? 'Guardar presupuesto' : 'Save budget';
  String get saving => isRu ? 'Сохранение…' : isEs ? 'Guardando…' : 'Saving…';
  String get insufficientBalance => isRu ? 'Недостаточно средств в общем остатке' : isEs ? 'Fondos insuficientes en el saldo total' : 'Not enough funds in the total balance';
  String get budgetDepletedTitle => isRu ? 'Бюджет закончился' : isEs ? 'El presupuesto se ha agotado' : 'Budget depleted';
  String get budgetDepletedMessage => isRu
      ? 'Средства текущего бюджета полностью потрачены.\nСоставьте новый бюджет, чтобы продолжить.'
      : isEs
          ? 'Has gastado todo el presupuesto actual.\nCrea un nuevo presupuesto para continuar.'
          : 'You have spent the entire current budget.\nCreate a new budget to continue.';
  String get createNewBudget => isRu ? 'Составить новый бюджет' : isEs ? 'Crear nuevo presupuesto' : 'Create new budget';
  String get dayCompleted => isRu ? 'День завершён' : isEs ? 'Día terminado' : 'Day completed';
  String remainingForDay(String date, String amount) => isRu
      ? 'Остаток за $date: $amount'
      : isEs
          ? 'Restante del $date: $amount'
          : 'Remaining for $date: $amount';
  String get carryover => isRu ? 'Перенести остаток на завтра' : isEs ? 'Transferir el resto a mañana' : 'Carry the remainder to tomorrow';
  String get redistribute => isRu ? 'Перераспределить на оставшиеся дни' : isEs ? 'Redistribuir entre los días restantes' : 'Redistribute across the remaining days';
  String get periodCompleted => isRu ? 'Ура! Бюджетный период завершён!' : isEs ? '¡Hurra! ¡El periodo del presupuesto ha terminado!' : 'Hooray! The budget period is complete!';
  String get hooray => isRu ? 'Ура!' : isEs ? '¡Hurra!' : 'Hooray!';
  String get congratulations => isRu ? 'Поздравляем!' : isEs ? '¡Felicidades!' : 'Congratulations!';
  String get finalAnimationPlaceholder => isRu ? 'Здесь будет финальная анимация енота.' : isEs ? 'Aquí aparecerá la animación final del mapache.' : 'The final raccoon animation will appear here.';
  String get setNewBudget => isRu ? 'Установить новый бюджет' : isEs ? 'Establecer nuevo presupuesto' : 'Set new budget';
  String get language => isRu ? 'Язык' : isEs ? 'Idioma' : 'Language';
  String get riveLoadError => isRu ? 'Ошибка загрузки Rive:' : isEs ? 'Error al cargar Rive:' : 'Rive loading error:';
  String get period => isRu ? 'Период' : isEs ? 'Periodo' : 'Period';
  String get daysWord => isRu ? 'день' : isEs ? 'día' : 'day';

  String days(int count) {
    if (isEs) return count == 1 ? '1 día' : '$count días';
    if (!isRu) return count == 1 ? '1 day' : '$count days';
    if (count % 10 == 1 && count % 100 != 11) return '$count день';
    if (count % 10 >= 2 && count % 10 <= 4 && (count % 100 < 10 || count % 100 >= 20)) return '$count дня';
    return '$count дней';
  }
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Mi presupuesto';

  @override
  String get chooseLanguage => 'Elige un idioma';

  @override
  String get todayAvailable => 'Disponible hoy';

  @override
  String get addExpense => 'Añadir gasto';

  @override
  String get allUnderControl => 'Todo bajo control';

  @override
  String get todayLimitLabel => 'Del límite diario';

  @override
  String get spentTodayLabel => 'Gastado hoy';

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count días',
      one: '$count día',
      zero: '$count días',
    );
    return '$_temp0';
  }

  @override
  String get balanceLabel => 'Total restante';

  @override
  String get daysLeftLabel => 'Hasta el día de pago';

  @override
  String get expenseTitle => 'Añadir gasto';

  @override
  String get amountHint => 'Importe';

  @override
  String get cancel => 'Cancelar';

  @override
  String get add => 'Añadir';

  @override
  String get insufficientFunds => 'No hay suficientes fondos en el saldo total';

  @override
  String get dayFinished => 'Día terminado';

  @override
  String remainingForDate(Object amount, Object date) {
    return 'Restante del $date: $amount';
  }

  @override
  String get carryover => 'Pasar el resto a mañana';

  @override
  String get redistribute => 'Redistribuir entre los días restantes';

  @override
  String get periodCompletedTitle =>
      '¡Hurra! ¡El periodo del presupuesto ha terminado!';

  @override
  String get hooray => '¡Hurra!';

  @override
  String get congratulations => '¡Felicidades!';

  @override
  String get finalAnimationPlaceholder =>
      'Aquí estará la animación final del mapache.';

  @override
  String get setNewBudget => 'Establecer un nuevo presupuesto';

  @override
  String get newBudget => 'Nuevo presupuesto';

  @override
  String get totalAmount => 'Importe total';

  @override
  String get chooseLastDay => 'Elige el último día del presupuesto';

  @override
  String period(Object end, Object start) {
    return 'Periodo: $start — $end';
  }

  @override
  String get enterPositiveAmount => 'Introduce un importe mayor que cero';

  @override
  String get saving => 'Guardando…';

  @override
  String get saveBudget => 'Guardar presupuesto';

  @override
  String get budgetDepletedTitle => 'Presupuesto agotado';

  @override
  String get budgetDepletedBody =>
      'Has gastado todo el presupuesto actual. Crea un nuevo presupuesto para continuar.';

  @override
  String get createNewBudget => 'Crear un nuevo presupuesto';

  @override
  String get languageTooltip => 'Idioma';

  @override
  String riveLoadError(Object error) {
    return 'Error al cargar Rive:\n$error';
  }
}

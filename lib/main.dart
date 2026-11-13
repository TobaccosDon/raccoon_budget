
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rive/rive.dart';
import 'package:intl/intl.dart';

import 'budget_data.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await RiveNative.init();

  final preferences = SharedPreferencesAsync();

  final savedLanguage = await preferences.getString('language');

  const supportedLanguages = ['en', 'ru', 'es'];

  final initialLocale = supportedLanguages.contains(savedLanguage)
      ? Locale(savedLanguage!)
      : null;

  // A missing saved daily limit means this is a fresh install with no budget.
  // Persist the planning state before the first screen is created so the
  // existing workflow restores the budget setup screen on every platform.
  final storedDailyLimit = await preferences.getInt('budget_dailyLimit');
  final storedWorkflowState =
      await preferences.getString('budget_workflow_state');

  if (storedDailyLimit == null && storedWorkflowState == null) {
    await preferences.setString('budget_workflow_state', 'budgetPlanning');
  }

  final savedDailyLimit = storedDailyLimit ?? 3000;
  final budget = BudgetData(
    dailyLimit: savedDailyLimit,
    baseDailyLimit:
        await preferences.getInt('budget_baseDailyLimit') ?? savedDailyLimit,
    spentToday:
        await preferences.getInt('budget_spentToday') ?? 0,
    balance:
        await preferences.getInt('budget_balance') ?? 0,
    daysLeft:
        await preferences.getInt('budget_daysLeft') ?? 0,
  );

  runApp(
    BudgetApp(
      initialLocale: initialLocale,
      preferences: preferences,
      budget: budget,
    ),
  );
}

class BudgetApp extends StatefulWidget {
  const BudgetApp({
    super.key,
    required this.preferences,
    required this.budget,
    this.initialLocale,
  });

  final Locale? initialLocale;
  final SharedPreferencesAsync preferences;
  final BudgetData budget;

  @override
  State<BudgetApp> createState() => _BudgetAppState();
}

class _BudgetAppState extends State<BudgetApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale;
  }

  Future<void> _changeLanguage(String languageCode) async {
    setState(() {
      _locale = Locale(languageCode);
    });

    await widget.preferences.setString(
      'language',
      languageCode,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates:
          AppLocalizations.localizationsDelegates,
      onGenerateTitle: (context) =>
          AppLocalizations.of(context)!.appTitle,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFFAF2),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF285943),
        ),
      ),
      home: BudgetScreen(
        onLanguageChanged: _changeLanguage,
        budget: widget.budget,
        preferences: widget.preferences,
      ),
    );
  }
}

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({
    super.key,
    required this.onLanguageChanged,
    required this.budget,
    required this.preferences,
  });

  final ValueChanged<String> onLanguageChanged;
  final BudgetData budget;
  final SharedPreferencesAsync preferences;

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _AccountantRaccoonView extends StatelessWidget {
  const _AccountantRaccoonView();

  @override
  Widget build(BuildContext context) {
    return RiveWidgetBuilder(
      fileLoader: FileLoader.fromAsset(
        'assets/raccoon_budget.riv',
        riveFactory: Factory.rive,
      ),
      artboardSelector: ArtboardSelector.byName('AccountantRaccoon'),
      stateMachineSelector: StateMachineSelector.byName('AccountantSM'),
      builder: (context, state) {
        if (state is RiveLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is RiveFailed) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEEEE),
              border: Border.all(color: Colors.redAccent),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SelectableText(
              'AccountantRaccoon load error:\n${state.error}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red, fontSize: 11),
            ),
          );
        }

        if (state is RiveLoaded) {
          return RiveWidget(
            controller: state.controller,
            fit: Fit.contain,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}


class _RaccoonVictoryView extends StatelessWidget {
  const _RaccoonVictoryView();

  @override
  Widget build(BuildContext context) {
    return RiveWidgetBuilder(
      fileLoader: FileLoader.fromAsset(
        'assets/raccoon_budget.riv',
        riveFactory: Factory.rive,
      ),
      artboardSelector: ArtboardSelector.byName('RaccoonVictory'),
      stateMachineSelector: StateMachineSelector.byName('VictorySM'),
      builder: (context, state) {
        if (state is RiveLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is RiveFailed) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEEEE),
              border: Border.all(color: Colors.redAccent),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SelectableText(
              'RiveVictory load error:\\n${state.error}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          );
        }

        if (state is RiveLoaded) {
          return RiveWidget(
            controller: state.controller,
            fit: Fit.contain,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _ExpenseDialog extends StatefulWidget {
  const _ExpenseDialog();

  @override
  State<_ExpenseDialog> createState() => _ExpenseDialogState();
}

class _ExpenseDialogState extends State<_ExpenseDialog> {

  AppLocalizations get texts => AppLocalizations.of(context)!;
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final value = int.tryParse(_controller.text.trim());

    if (value == null || value <= 0) {
      return;
    }

    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(texts.addExpense),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        autofocus: true,
        decoration: InputDecoration(
          hintText: texts.amountHint,
        ),
        onSubmitted: (_) {
          _submit();
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(texts.cancel),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(texts.add),
        ),
      ],
    );
  }
}

class _NewBudgetForm extends StatefulWidget {
  const _NewBudgetForm({required this.onSave});

  final Future<void> Function(int amount, int days) onSave;

  @override
  State<_NewBudgetForm> createState() => _NewBudgetFormState();
}

class _NewBudgetFormState extends State<_NewBudgetForm> {

  AppLocalizations get texts => AppLocalizations.of(context)!;
  final TextEditingController _amountController =
      TextEditingController(text: '30000');
  final ScrollController _daysScrollController = ScrollController();
  int _days = 30;
  bool _saving = false;

  @override
  void dispose() {
    _amountController.dispose();
    _daysScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final start = DateTime.now();
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 460),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 132,
            width: double.infinity,
            child: _AccountantRaccoonView(),
          ),
          const SizedBox(height: 8),
          Text(
            texts.newBudget,
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: texts.totalAmount,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              texts.chooseLastDay,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 280,
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Scrollbar(
              controller: _daysScrollController,
              thumbVisibility: true,
              trackVisibility: true,
              interactive: true,
              thickness: 6,
              radius: const Radius.circular(8),
              child: ListView.builder(
                controller: _daysScrollController,
                itemCount: 31,
              itemBuilder: (context, index) {
                final days = index + 1;
                final date = DateTime(
                  start.year,
                  start.month,
                  start.day + index,
                );
                final selected = days == _days;

                return ListTile(
                  enabled: !_saving,
                  selected: selected,
                  leading: SizedBox(
                    width: 42,
                    child: Text(
                      texts.dayCount(days),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  title: Text(DateFormat('dd.MM.yyyy').format(date)),
                  trailing: selected
                      ? const Icon(Icons.check_circle)
                      : null,
                  onTap: _saving
                      ? null
                      : () => setState(() => _days = days),
                );
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            texts.period(
              DateFormat('dd.MM.yyyy').format(start),
              DateFormat('dd.MM.yyyy').format(
                DateTime(start.year, start.month, start.day + _days - 1),
              ),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _saving
                  ? null
                  : () async {
                      final amount = int.tryParse(_amountController.text);
                      if (amount == null || amount <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(texts.enterPositiveAmount),
                          ),
                        );
                        return;
                      }
                      setState(() => _saving = true);
                      try {
                        await widget.onSave(amount, _days);
                      } finally {
                        if (mounted) setState(() => _saving = false);
                      }
                    },
              child: Text(_saving ? texts.saving : texts.saveBudget),
            ),
          ),
        ],
      ),
    );
  }
}

class _BudgetScreenState extends State<BudgetScreen>
    with WidgetsBindingObserver {
  AppLocalizations get texts => AppLocalizations.of(context)!;
  static const String _budgetDateKey = 'budget_day_date';
  static const String _pendingReviewDateKey = 'budget_pending_review_date';
  static const String _targetReviewDateKey = 'budget_target_review_date';
  static const String _workflowStateKey = 'budget_workflow_state';
  static const String _reviewChoiceKey = 'budget_review_choice';

  dynamic _viewModel;
  bool _dayTrackingInitialized = false;
  bool _needsDayReview = false;
  String? _pendingReviewDate;
  String? _targetReviewDate;
  bool _checkingBudgetDate = false;
  String _workflowState = 'active';
  bool _savingReviewChoice = false;
  bool _startingNewBudget = false;
  int _missedDays = 1;

  // Rive mascot state. The four normal states are selected from the current
  // daily allowance; PLUS and 1zRasch are one-shot states.
  String _mascotStateMachine = 'EnotTimeline100';
  bool _mascotAnimationPlaying = false;

  static const Duration _oneShotMascotDuration = Duration(milliseconds: 1800);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _mascotStateMachine = _normalMascotStateMachine();
    _checkBudgetDate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkBudgetDate();
    }
  }

  String _dateKey(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  DateTime _parseDateKey(String value) {
    final parts = value.split('-').map(int.parse).toList();
    return DateTime(parts[0], parts[1], parts[2]);
  }

  int get _accumulatedCarryover {
    final firstDayRemainder =
        widget.budget.availableToday.clamp(0, 1 << 30).toInt();
    final followingDaysRemainder =
        widget.budget.baseDailyLimit * (_missedDays - 1);
    return firstDayRemainder + followingDaysRemainder;
  }

  Future<void> _finishExpiredPeriod(String today) async {
    widget.budget.daysLeft = 0;
    await _saveBudget();
    await widget.preferences.remove(_pendingReviewDateKey);
    await widget.preferences.remove(_targetReviewDateKey);
    await widget.preferences.setString(_budgetDateKey, today);
    await widget.preferences.setString(_workflowStateKey, 'successAnimation');

    if (!mounted) return;
    setState(() {
      _workflowState = 'successAnimation';
      _needsDayReview = false;
      _pendingReviewDate = null;
      _targetReviewDate = null;
      _dayTrackingInitialized = true;
    });
  }

  Future<void> _checkBudgetDate() async {
    if (_checkingBudgetDate) return;
    _checkingBudgetDate = true;

    try {
      final today = _dateKey(DateTime.now());
      final savedWorkflowState =
          await widget.preferences.getString(_workflowStateKey);
      final savedDate = await widget.preferences.getString(_budgetDateKey);
      final savedPendingDate =
          await widget.preferences.getString(_pendingReviewDateKey);

      if (!mounted) return;

      if (savedWorkflowState == 'periodCompleted' ||
          savedWorkflowState == 'successAnimation' ||
          savedWorkflowState == 'budgetPlanning') {
        final restoredState = savedWorkflowState == 'periodCompleted'
            ? 'successAnimation'
            : savedWorkflowState!;

        if (restoredState != savedWorkflowState) {
          await widget.preferences.setString(
            _workflowStateKey,
            restoredState,
          );
        }

        setState(() {
          _workflowState = restoredState;
          _dayTrackingInitialized = true;
          _needsDayReview = false;
        });

        return;
      }

      if (savedWorkflowState == 'budgetDepleted' ||
          (savedWorkflowState == null &&
              savedDate != null &&
              widget.budget.balance <= 0)) {
        await widget.preferences.setString(_workflowStateKey, 'budgetDepleted');
        if (!mounted) return;
        setState(() {
          _workflowState = 'budgetDepleted';
          _dayTrackingInitialized = true;
          _needsDayReview = false;
        });
        return;
      }

      // If a review was already pending, extend it to the actual current date.
      // This handles another few days passing while the review screen was closed.
      final reviewStartDate = savedPendingDate ?? savedDate;

      // On first launch, establish the baseline date; do not invent a prior day.
      if (reviewStartDate == null) {
        await widget.preferences.setString(_budgetDateKey, today);
        if (!mounted) return;
        setState(() {
          _needsDayReview = false;
          _pendingReviewDate = null;
          _targetReviewDate = null;
          _missedDays = 1;
          _workflowState = 'active';
          _dayTrackingInitialized = true;
        });
        return;
      }

      final missedDays = _parseDateKey(today)
          .difference(_parseDateKey(reviewStartDate))
          .inDays;

      if (missedDays <= 0) {
        // A clock correction backwards must not create a negative day count.
        if (savedPendingDate != null) {
          await widget.preferences.remove(_pendingReviewDateKey);
          await widget.preferences.remove(_targetReviewDateKey);
          await widget.preferences.setString(_workflowStateKey, 'active');
        }
        if (!mounted) return;
        setState(() {
          _needsDayReview = false;
          _workflowState = 'active';
          _pendingReviewDate = null;
          _targetReviewDate = null;
          _missedDays = 1;
          _dayTrackingInitialized = true;
        });
        return;
      }

      // The budget period has already elapsed. Do not show a day-review choice
      // when there are no days left to carry money into or redistribute across.
      if (missedDays >= widget.budget.daysLeft) {
        await _finishExpiredPeriod(today);
        return;
      }

      await widget.preferences.setString(_pendingReviewDateKey, reviewStartDate);
      await widget.preferences.setString(_targetReviewDateKey, today);
      await widget.preferences.setString(_workflowStateKey, 'dayReview');

      if (!mounted) return;
      setState(() {
        _needsDayReview = true;
        _workflowState = 'dayReview';
        _pendingReviewDate = reviewStartDate;
        _targetReviewDate = today;
        _missedDays = missedDays;
        _dayTrackingInitialized = true;
      });
    } finally {
      _checkingBudgetDate = false;
    }
  }

  Future<void> _resolveDayReview(String choice) async {
    if (_savingReviewChoice || !_needsDayReview || _mascotAnimationPlaying) {
      return;
    }

    final accumulatedCarryover = _accumulatedCarryover;

    // Carryover is available only when at least one positive amount accumulated.
    if (choice == 'carryover' && accumulatedCarryover <= 0) {
      return;
    }

    if (choice != 'carryover' && choice != 'redistribute') {
      return;
    }

    setState(() {
      _savingReviewChoice = true;
      _mascotAnimationPlaying = true;
      _mascotStateMachine = 'EnotTimelinePLUS';
    });

    try {
      // The PLUS state is a short one-shot Rive animation.
      // Until a dedicated Rive event is added, keep the UI blocked for the
      // animation duration configured here.
      await Future<void>.delayed(_oneShotMascotDuration);

      if (!mounted) return;

      final today = _dateKey(DateTime.now());
      final completedDays = _missedDays.clamp(1, widget.budget.daysLeft).toInt();
      final futureDays = (widget.budget.daysLeft - completedDays)
          .clamp(0, 31)
          .toInt();

      // Close every elapsed day. No expenses are assumed for days on which
      // the user did not open the app; their ordinary allowance accumulates.
      widget.budget.spentToday = 0;
      widget.budget.daysLeft = futureDays;

      if (futureDays > 0) {
        if (choice == 'carryover') {
          // The first missed day contributes its actual unused amount; each
          // following unattended day contributes one full base daily allowance.
          widget.budget.dailyLimit =
              widget.budget.baseDailyLimit + accumulatedCarryover;
        } else {
          // Re-split the entire remaining balance equally across future days.
          final recalculatedLimit = widget.budget.balance ~/ futureDays;
          widget.budget
            ..baseDailyLimit = recalculatedLimit
            ..dailyLimit = recalculatedLimit;
        }
      }

      await _saveBudget();

      await widget.preferences.remove(_pendingReviewDateKey);
      await widget.preferences.remove(_targetReviewDateKey);
      await widget.preferences.setString(_budgetDateKey, today);
      await widget.preferences.setString(_reviewChoiceKey, choice);

      final nextState = widget.budget.daysLeft <= 0
          ? 'successAnimation'
          : 'active';
      await widget.preferences.setString(_workflowStateKey, nextState);

      if (!mounted) return;
      setState(() {
        _needsDayReview = false;
        _pendingReviewDate = null;
        _targetReviewDate = null;
        _missedDays = 1;
        _workflowState = nextState;
        _mascotAnimationPlaying = false;
      });

      _setNormalMascotState();
      _updateRiveBudget();
    } finally {
      if (mounted) {
        setState(() {
          _savingReviewChoice = false;
          _mascotAnimationPlaying = false;
        });
      }
    }
  }

  Future<void> _startBudgetPlanning() async {
    await widget.preferences.setString(
      _workflowStateKey,
      'budgetPlanning',
    );
    if (!mounted) return;
    setState(() {
      _workflowState = 'budgetPlanning';
    });
  }

  Future<void> _saveBudget() async {
    await widget.preferences.setInt(
      'budget_dailyLimit',
      widget.budget.dailyLimit,
    );

    await widget.preferences.setInt(
      'budget_baseDailyLimit',
      widget.budget.baseDailyLimit,
    );

    await widget.preferences.setInt(
      'budget_spentToday',
      widget.budget.spentToday,
    );

    await widget.preferences.setInt(
      'budget_balance',
      widget.budget.balance,
    );

    await widget.preferences.setInt(
      'budget_daysLeft',
      widget.budget.daysLeft,
    );
  }

  Future<void> _addExpense() async {
    if (_mascotAnimationPlaying) return;

    final amount = await showDialog<int>(
      context: context,
      builder: (context) {
        return const _ExpenseDialog();
      },
    );

    if (!mounted || amount == null) {
      return;
    }

    if (amount > widget.budget.balance) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            texts.insufficientFunds,
          ),
        ),
      );
      return;
    }

    widget.budget.spentToday += amount;
    widget.budget.balance -= amount;

    await _saveBudget();

    final exceededDailyLimit = widget.budget.availableToday < 0;

    if (exceededDailyLimit) {
      // One-shot reaction to an expense that pushed today's allowance below 0.
      // After the animation the normal mascot state becomes Zero.
      setState(() {
        _mascotStateMachine = 'EnotTimelineIzRasch';
        _mascotAnimationPlaying = true;
      });

      await Future<void>.delayed(_oneShotMascotDuration);

      if (!mounted) return;

      setState(() {
        _mascotAnimationPlaying = false;
        _mascotStateMachine = 'EnotTimelineZero';
      });
    }

    if (widget.budget.balance <= 0) {
      await widget.preferences.setString(_workflowStateKey, 'budgetDepleted');
      if (!mounted) return;
      setState(() {
        _workflowState = 'budgetDepleted';
      });
    }

    if (!exceededDailyLimit) {
      _setNormalMascotState();
    }

    _updateRiveBudget();
  }

  Future<void> _openNewBudgetFromActive() async {
    if (_startingNewBudget || _workflowState == 'budgetPlanning') return;
    setState(() => _startingNewBudget = true);
    try {
      await _startBudgetPlanning();
    } finally {
      if (mounted) setState(() => _startingNewBudget = false);
    }
  }

  Widget _buildBudgetDepletedOverlay(BuildContext context) {
    return PopScope(
      canPop: false,
      child: ColoredBox(
        color: const Color(0xFFFFFAF2),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.account_balance_wallet_outlined, size: 72),
                  const SizedBox(height: 20),
                  Text(texts.budgetDepletedTitle, textAlign: TextAlign.center, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(texts.budgetDepletedBody, textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _startingNewBudget ? null : _openNewBudgetFromActive,
                    child: Text(texts.createNewBudget),
                  ),
                  if (_startingNewBudget) ...[
                    const SizedBox(height: 16),
                    const CircularProgressIndicator(),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDayReviewOverlay(BuildContext context) {
    final numberFormat = NumberFormat.decimalPattern(
      Localizations.localeOf(context).languageCode,
    );
    final remaining = _accumulatedCarryover;

    return PopScope(
      canPop: false,
      child: ColoredBox(
        color: const Color(0xFFFFFAF2),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 150,
                      width: double.infinity,
                      child: _AccountantRaccoonView(),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      texts.dayFinished,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      texts.remainingForDate(
                        _pendingReviewDate ?? 'previous day',
                        numberFormat.format(remaining),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    if (_accumulatedCarryover > 0 &&
                        widget.budget.daysLeft > _missedDays) ...[
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _savingReviewChoice
                              ? null
                              : () => _resolveDayReview('carryover'),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(texts.carryover),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (widget.budget.daysLeft > _missedDays &&
                        widget.budget.balance > 0)
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: _savingReviewChoice
                              ? null
                              : () => _resolveDayReview('redistribute'),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(texts.redistribute),
                        ),
                      ),
                    ),
                    if (_savingReviewChoice) ...[
                      const SizedBox(height: 16),
                      const CircularProgressIndicator(),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessAnimationOverlay(BuildContext context) {
    return PopScope(
      canPop: false,
      child: ColoredBox(
        color: const Color(0xFFFFFAF2),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 260,
                      width: double.infinity,
                      child: _RaccoonVictoryView(),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      texts.congratulations,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _startBudgetPlanning,
                        child: Text(texts.setNewBudget),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBudgetPlanningOverlay(BuildContext context) {
    return PopScope(
      canPop: false,
      child: ColoredBox(
        color: const Color(0xFFFFFAF2),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: _NewBudgetForm(
                onSave: (amount, days) async {
                  final newDailyLimit = amount ~/ days;
                  widget.budget
                    ..baseDailyLimit = newDailyLimit
                    ..dailyLimit = newDailyLimit
                    ..spentToday = 0
                    ..balance = amount
                    ..daysLeft = days;
                  await _saveBudget();
                  await widget.preferences.setString(
                    _budgetDateKey,
                    _dateKey(DateTime.now()),
                  );
                  await widget.preferences.remove(_pendingReviewDateKey);
                  await widget.preferences.remove(_targetReviewDateKey);
                  await widget.preferences.setString(
                    _workflowStateKey,
                    'active',
                  );
                  if (!mounted) return;
                  setState(() {
                    _workflowState = 'active';
                    _needsDayReview = false;
                    _pendingReviewDate = null;
                    _targetReviewDate = null;
                  });
                  _setNormalMascotState();
                  _updateRiveBudget();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _normalMascotStateMachine() {
    final dailyLimit = widget.budget.dailyLimit;
    final availableToday = widget.budget.availableToday;

    if (dailyLimit <= 0 || availableToday <= 0) {
      return 'EnotTimelineZero';
    }

    final ratio = availableToday / dailyLimit;

    if (ratio >= 0.60) {
      return 'EnotTimeline100';
    }
    if (ratio >= 0.30) {
      return 'EnotTimeline60';
    }
    return 'EnotTimeline30';
  }

  void _setNormalMascotState() {
    if (_mascotAnimationPlaying) return;
    final next = _normalMascotStateMachine();
    if (_mascotStateMachine == next) return;
    if (mounted) {
      setState(() {
        _mascotStateMachine = next;
      });
    } else {
      _mascotStateMachine = next;
    }
  }


  void _updateRiveBudget() {
    final viewModel = _viewModel;

    if (viewModel == null) {
      return;
    }

    final locale = Localizations.localeOf(context);

    final numberFormat = NumberFormat.decimalPattern(
      locale.languageCode,
    );

    final todayLabel = viewModel.string('todayLabelText');

    if (todayLabel != null) {
      todayLabel.value = texts.todayAvailable;
    }

    final todayAmount = viewModel.string('todayAmountText');

    if (todayAmount != null) {
      todayAmount.value =
          numberFormat.format(widget.budget.availableToday);
    }

    final balanceLabel = viewModel.string('balanceLabelText');

    if (balanceLabel != null) {
      balanceLabel.value = texts.balanceLabel;
    }

    final daysLeftLabel = viewModel.string('daysLeftLabelText');

    if (daysLeftLabel != null) {
      daysLeftLabel.value = texts.daysLeftLabel;
    }

    final balanceAmount = viewModel.string('balanceAmountText');

    if (balanceAmount != null) {
      balanceAmount.value =
          numberFormat.format(widget.budget.balance);
    }

    final todayLimit = viewModel.string('todayLimitText');

    if (todayLimit != null) {
      todayLimit.value = numberFormat.format(widget.budget.dailyLimit);
    }

    final daysLeft = viewModel.string('daysLeftText');

    if (daysLeft != null) {
      daysLeft.value = texts.dayCount(widget.budget.daysLeft);
    }

    final spentToday = viewModel.string('spentTodayText');

    if (spentToday != null) {
      spentToday.value =
          numberFormat.format(widget.budget.spentToday);
    }

    final progressWidth = viewModel.number('progressWidth');

    if (progressWidth != null) {
      progressWidth.value = widget.budget.progressWidth;
    }
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);

    final numberFormat = NumberFormat.decimalPattern(
      locale.languageCode,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFFFAF2),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: RiveWidgetBuilder(
                key: ValueKey(_mascotStateMachine),
                stateMachineSelector: StateMachineSelector.byName(
                  _mascotStateMachine,
                ),
                fileLoader: FileLoader.fromAsset(
                  'assets/raccoon_budget.riv',
                  riveFactory: Factory.rive,
                ),
                // The main screen must always use the BudgetHome artboard.
                // Otherwise Rive may select AccountantRaccoon by default,
                // where the EnotTimeline* state machines do not exist.
                artboardSelector: ArtboardSelector.byName('BudgetHome'),
                dataBind: DataBind.auto(),
                builder: (context, state) {
                  if (state is RiveLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is RiveFailed) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          texts.riveLoadError(state.error.toString()),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  if (state is RiveLoaded) {
                    _viewModel = state.viewModelInstance;

                    final viewModel = _viewModel;

                    if (viewModel != null) {
                      final title = viewModel.string('titleText');

                      if (title != null) {
                        title.value = texts.appTitle;
                      }

                      final todayLabel =
                          viewModel.string('todayLabelText');

                      if (todayLabel != null) {
                        todayLabel.value = texts.todayAvailable;
                      }

                      final todayAmount =
                          viewModel.string('todayAmountText');

                      if (todayAmount != null) {
                        todayAmount.value =
                            numberFormat.format(
                          widget.budget.availableToday,
                        );
                      }

                      final todayLimit =
                          viewModel.string('todayLimitText');

                      if (todayLimit != null) {
                        todayLimit.value =
                            numberFormat.format(
                          widget.budget.dailyLimit,
                        );
                      }

                      final balanceLabel =
                          viewModel.string('balanceLabelText');

                      if (balanceLabel != null) {
                        balanceLabel.value = texts.balanceLabel;
                      }

                      final balanceAmount =
                          viewModel.string('balanceAmountText');

                      if (balanceAmount != null) {
                        balanceAmount.value =
                            numberFormat.format(
                          widget.budget.balance,
                        );
                      }

                      final daysLeftLabel =
                          viewModel.string('daysLeftLabelText');

                      if (daysLeftLabel != null) {
                        daysLeftLabel.value = texts.daysLeftLabel;
                      }

                      final daysLeft =
                          viewModel.string('daysLeftText');

                      if (daysLeft != null) {
                        daysLeft.value = texts.dayCount(widget.budget.daysLeft);
                      }

                      final spentToday =
                          viewModel.string('spentTodayText');

                      if (spentToday != null) {
                        spentToday.value =
                            numberFormat.format(
                          widget.budget.spentToday,
                        );
                      }

                      final progressWidth =
                          viewModel.number('progressWidth');

                      if (progressWidth != null) {
                        progressWidth.value =
                            widget.budget.progressWidth;
                      }
                    }

                    return RiveWidget(
                      controller: state.controller,
                      fit: Fit.contain,
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),

            if (_dayTrackingInitialized &&
                (_workflowState == 'dayReview' || _needsDayReview))
              Positioned.fill(
                child: _buildDayReviewOverlay(context),
              ),

            if (_dayTrackingInitialized &&
                _workflowState == 'budgetDepleted')
              Positioned.fill(
                child: _buildBudgetDepletedOverlay(context),
              ),

            if (_dayTrackingInitialized &&
                _workflowState == 'successAnimation')
              Positioned.fill(
                child: _buildSuccessAnimationOverlay(context),
              ),

            if (_dayTrackingInitialized &&
                _workflowState == 'budgetPlanning')
              Positioned.fill(
                child: _buildBudgetPlanningOverlay(context),
              ),

            if (_dayTrackingInitialized && _workflowState == 'active')
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton.extended(
                  onPressed: _mascotAnimationPlaying ? null : _addExpense,
                  icon: const Icon(Icons.add),
                  label: Text(texts.addExpense),
                ),
              ),

            // Выбор языка доступен независимо от состояния бюджетного дня.
            Positioned(
              top: 8,
              right: 8,
              child: Material(
                color: Colors.white.withValues(alpha: 0.92),
                shape: const CircleBorder(),
                child: PopupMenuButton<String>(
                  tooltip: texts.languageTooltip,
                  icon: const Icon(Icons.menu),
                  onSelected: (value) {
                    if (value == '__new_budget__') {
                      _openNewBudgetFromActive();
                    } else {
                      widget.onLanguageChanged(value);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: '__new_budget__',
                      child: Text(texts.createNewBudget),
                    ),
                    PopupMenuDivider(),
                    PopupMenuItem(
                      value: 'ru',
                      child: Text('Русский'),
                    ),
                    PopupMenuItem(
                      value: 'en',
                      child: Text('English'),
                    ),
                    PopupMenuItem(
                      value: 'es',
                      child: Text('Español'),
                    ),
                  ],
                ),
              ),
            ),



          ],
        ),
      ),
    );
  }
}

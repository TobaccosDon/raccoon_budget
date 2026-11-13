class BudgetData {
  BudgetData({
    this.dailyLimit = 3000,
    int? baseDailyLimit,
    this.spentToday = 800,
    this.balance = 29200,
    this.daysLeft = 9,
  }) : baseDailyLimit = baseDailyLimit ?? dailyLimit;

  int dailyLimit;
  int baseDailyLimit;
  int spentToday;
  int balance;
  int daysLeft;

  int get availableToday => dailyLimit - spentToday;

  int get remainingSpendableToday {
    if (balance <= 0 || availableToday <= 0) {
      return 0;
    }

    return availableToday < balance ? availableToday : balance;
  }

double get progressWidth {
  if (dailyLimit <= 0) return 0.0;

  final remaining = availableToday.clamp(0, dailyLimit);
  final progress = remaining / dailyLimit;

  return (progress * 342).clamp(0.0, 342.0);
}
}
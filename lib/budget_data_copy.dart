
class BudgetData {
  BudgetData({
    this.dailyLimit = 3000,
    this.spentToday = 800,
    this.balance = 29200,
    this.daysLeft = 9,
  });

  int dailyLimit;
  int spentToday;
  int balance;
  int daysLeft;

  int get availableToday => dailyLimit - spentToday;

  double get progressWidth {
    if (dailyLimit <= 0) {
      return 0;
    }

    final progress = spentToday / dailyLimit;
    return (progress * 342).clamp(0.0, 342.0);
  }
}

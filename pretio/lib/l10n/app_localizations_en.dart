// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Time Cost Calculator';

  @override
  String get balance => 'Balance';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get calendar => 'Calendar';

  @override
  String get reports => 'Reports';

  @override
  String get settings => 'Settings';

  @override
  String get theme => 'Theme';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get analytics => 'Analytics';

  @override
  String get coach => 'Coach';

  @override
  String get shadow => 'Shadow';

  @override
  String get time => 'Time';

  @override
  String get profile => 'Profile';

  @override
  String get setDailyGoal => 'Set Daily Goal';

  @override
  String get addQuickAmount => 'Add Quick Amount';

  @override
  String get needs => 'Needs';

  @override
  String get wants => 'Wants';

  @override
  String get total => 'Total';

  @override
  String get currentStreak => 'Current Streak';

  @override
  String get longestStreak => 'Longest Streak';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get add => 'Add';

  @override
  String get delete => 'Delete';

  @override
  String editAmount(double amount) {
    final intl.NumberFormat amountNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String amountString = amountNumberFormat.format(amount);

    return 'Edit Amount $amountString';
  }

  @override
  String get deleteAmountConfirmation =>
      'Do you want to delete this quick amount?';

  @override
  String get manage => 'Manage';

  @override
  String get done => 'Done';

  @override
  String get addTransaction => 'Add transaction';

  @override
  String get whatDidYouBuy => 'What did you buy?';

  @override
  String get howDoYouFeel => 'How do you feel about this?';

  @override
  String get isThisNeedOrWant => 'Is this a Need, Want or Necessity?';

  @override
  String get saveTransaction => 'Save Transaction';

  @override
  String get recentActivity => 'Recent Activity';

  @override
  String get viewAll => 'View All';

  @override
  String get noRecentActivity => 'No recent activity';

  @override
  String get newCategory => 'New Category';

  @override
  String get categoryName => 'Category Name';

  @override
  String get selectIcon => 'Select Icon';

  @override
  String get selectColor => 'Select Color';

  @override
  String get create => 'Create';

  @override
  String get shadowBudget => 'Shadow Budget';

  @override
  String get item => 'Item';

  @override
  String get price => 'Price';

  @override
  String get howDidItFeel => 'How did it feel not buying it?';

  @override
  String get proud => 'Proud';

  @override
  String get relieved => 'Relieved';

  @override
  String get sad => 'Sad';

  @override
  String get iDidntBuyIt => 'I Didn\'t Buy It!';

  @override
  String totalSaved(double amount) {
    final intl.NumberFormat amountNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String amountString = amountNumberFormat.format(amount);

    return 'Total Saved: $amountString';
  }

  @override
  String get examples => 'EXAMPLES';

  @override
  String memberSince(int year) {
    return 'Member since $year';
  }

  @override
  String get financialHealth => 'Financial Health';

  @override
  String get excellent => 'Excellent';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get annualSalary => 'Annual Salary';

  @override
  String get weeklyHours => 'Weekly Hours';

  @override
  String get appPreferences => 'App Preferences';

  @override
  String get notifications => 'Notifications';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get security => 'Security';

  @override
  String get faceIdLogin => 'FaceID Login';

  @override
  String get changePassword => 'Change Password';

  @override
  String get timeValue => 'Time Value';

  @override
  String get yourProfileShared => 'YOUR PROFILE (Shared)';

  @override
  String get monthlySalary => 'Monthly Salary';

  @override
  String get recalculateRate => 'Recalculate Rate';

  @override
  String get yourTimeIsWorth => 'Your time is worth';

  @override
  String get tlPhr => '/hr';

  @override
  String get howMuchLife => 'HOW MUCH LIFE DOES IT COST?';

  @override
  String get trends => 'Trends';

  @override
  String get noTransactionsYet => 'No transactions yet.';

  @override
  String get good => 'Good';

  @override
  String get okay => 'Okay';

  @override
  String get regret => 'Regret';

  @override
  String get overBudget => 'Over Budget';

  @override
  String get onTrack => 'On Track';

  @override
  String get monthlyAvg => 'MONTHLY AVG';

  @override
  String get day => 'Day';

  @override
  String get perDay => '/ day';

  @override
  String days(int count) {
    return '$count Days';
  }

  @override
  String get financialCoach => 'Financial Coach';

  @override
  String get moodVsMoney => 'Mood vs. Money';

  @override
  String get needVsWant => 'Need vs. Want';

  @override
  String deleteCategoryTitle(String category) {
    return 'Delete \"$category\"?';
  }

  @override
  String get deleteCategoryContent =>
      'This will only remove the category from your list. Existing transactions will keep this category name.';

  @override
  String get remaining => 'Remaining';

  @override
  String goal(double amount) {
    final intl.NumberFormat amountNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String amountString = amountNumberFormat.format(amount);

    return 'GOAL: $amountString';
  }

  @override
  String get transactionHistory => 'Transaction History';

  @override
  String get currency => 'Currency';

  @override
  String get editTransactionTitle => 'Edit Transaction';

  @override
  String get titleLabel => 'Title';

  @override
  String get amountLabel => 'Amount';

  @override
  String get favorite => 'Favorite';

  @override
  String get need => 'Need';

  @override
  String get want => 'Want';

  @override
  String get necessity => 'Necessity';

  @override
  String get spendingBalance => 'Spending Balance';

  @override
  String get emotionalImpact => 'Emotional Impact';

  @override
  String get budgetProgress => 'Budget Progress';

  @override
  String get weeklyLimit => 'Weekly Limit';

  @override
  String get monthlyLimit => 'Monthly Limit';

  @override
  String get underDailyGoal => 'under daily goal';

  @override
  String get overDailyGoal => 'over daily goal';

  @override
  String get fancyLatte => 'Fancy Latte';

  @override
  String get runningShoes => 'Running Shoes';

  @override
  String get flagshipPhone => 'Flagship Phone';

  @override
  String get sedanCar => 'Sedan Car';

  @override
  String get catFood => 'Food';

  @override
  String get catTransport => 'Transport';

  @override
  String get catShopping => 'Shopping';

  @override
  String get catFun => 'Fun';

  @override
  String get catBills => 'Bills';

  @override
  String get catOther => 'Other';

  @override
  String get phone => 'Phone';

  @override
  String get undoTransactionQuestion => 'Do you want to undo this transaction?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get addNote => 'Add Note';

  @override
  String get enterNote => 'Enter note here...';

  @override
  String get budgetPlanner => 'Budget Planner';

  @override
  String get pleaseEnterItemAndPrice => 'Please enter item and price';

  @override
  String get victorySaved => 'Victory Saved! 🎉';

  @override
  String get editGoal => 'Edit Goal';

  @override
  String get goalName => 'Goal Name';

  @override
  String get goalAmount => 'Goal Amount';

  @override
  String get rateUpdated => 'Rate Updated! 🚀';

  @override
  String get coffeeShoesEta => 'Coffee, Shoes etc.';

  @override
  String get howMuchWasIt => 'How much was it?';

  @override
  String get happy => 'Happy';

  @override
  String get neutral => 'Neutral';

  @override
  String get reclaimed => 'RECLAIMED';

  @override
  String get workHours => 'Work Hours';

  @override
  String get mountainOfSavings => 'Mountain of Savings';

  @override
  String levelX(int level) {
    return 'Level $level';
  }

  @override
  String get starting => 'Start';

  @override
  String get totalPool => 'Total Pool';

  @override
  String get discretionarySpending => 'Discretionary';

  @override
  String leftToPeak(int percent) {
    return '$percent% left to peak';
  }

  @override
  String get recentVictories => 'Recent Victories';

  @override
  String get noVictoriesYet => 'No victories recorded yet.';

  @override
  String savedHours(String hours) {
    return '$hours hours reclaimed';
  }

  @override
  String get edit => 'Edit';

  @override
  String get editVictory => 'Edit Victory';

  @override
  String get minShort => 'm';

  @override
  String get hrShort => 'h';

  @override
  String get workDay => 'work day';

  @override
  String get monthShort => 'month';

  @override
  String get workShort => 'work';

  @override
  String get categories => 'Categories';

  @override
  String get weekly => 'Weekly';

  @override
  String get monthly => 'Monthly';

  @override
  String get yearly => 'Yearly';

  @override
  String get goals => 'Goals';

  @override
  String get noSpendToast => 'Spending recorded today!';

  @override
  String get noSpendTitle => 'No spending';

  @override
  String get noSpendNote => 'No spending was done today';

  @override
  String get deletedData => 'Deleted Data';

  @override
  String get settingsAndPreferences => 'SETTINGS AND PREFERENCES';

  @override
  String get account => 'Account';

  @override
  String get profileNameLabel => 'PROFILE NAME';

  @override
  String get avatarLabel => 'AVATAR';

  @override
  String get personalizeCharacter => 'Personalize your character';

  @override
  String get changeAvatar => 'CHANGE AVATAR';

  @override
  String get balanceAndFinance => 'Balance and Finance';

  @override
  String get balanceInfoLabel => 'BALANCE INFO';

  @override
  String currentBalance(String amount) {
    return 'CURRENT: $amount';
  }

  @override
  String get currencyLabel => 'CURRENCY';

  @override
  String get appearance => 'Appearance';

  @override
  String get languageSelectionLabel => 'LANGUAGE SELECTION';

  @override
  String get themesLabel => 'THEMES';

  @override
  String get themeLight => 'Light';

  @override
  String get themeForest => 'Forest Green';

  @override
  String get themeCottonCandy => 'Cotton Candy';

  @override
  String get themeSunset => 'Sunset';

  @override
  String get themeProfileDark => 'Night Blue';

  @override
  String get themeAmoled => 'Dark';

  @override
  String get preferences => 'Preferences';

  @override
  String get hideSpentMoney => 'HIDE SPENT MONEY';

  @override
  String get privacyMode => 'Privacy mode';

  @override
  String get needWantModule => 'NEED - WANT MODULE';

  @override
  String get showWhenAddingNew => 'Show when adding new transaction';

  @override
  String get emotionModule => 'EMOTION MODULE';

  @override
  String get view3D => '3D VIEW';

  @override
  String get addEmbossEffect => 'Add emboss effect to cards';

  @override
  String get reset => 'Reset';

  @override
  String get deleteAll => 'DELETE EVERYTHING';

  @override
  String get deletePermanently => 'Delete all data permanently';

  @override
  String get buttonDelete => 'DELETE';

  @override
  String get about => 'About';

  @override
  String get appPurpose => 'APP PURPOSE';

  @override
  String get whyAreWeHere => 'Why are we here?';

  @override
  String get aboutApp => 'ABOUT APP';

  @override
  String get versionAndDetails => 'Version and details';

  @override
  String get creators => 'CREATORS';

  @override
  String get whoDevelopedIt => 'Who developed it?';

  @override
  String get selectAvatar => 'Select Avatar';

  @override
  String get editPhoto => 'Edit Photo';

  @override
  String get statistics => 'Statistics';

  @override
  String get highestStreak => 'HIGHEST STREAK';

  @override
  String get totalSpending => 'TOTAL SPENDING';

  @override
  String get currentStreakLabel => 'CURRENT STREAK';

  @override
  String get financialIq => 'Financial IQ';

  @override
  String percentNeed(int percent) {
    return '$percent% Need';
  }

  @override
  String percentWant(int percent) {
    return '$percent% Want';
  }

  @override
  String percentObligation(int percent) {
    return '$percent% Oblig.';
  }

  @override
  String get subscriptions => 'Subscriptions';

  @override
  String get seeAll => 'SEE ALL';

  @override
  String get noSubscriptionsYet => 'You haven\'t added any subscriptions yet.';

  @override
  String get badgesAndAchievements => 'Badges & Achievements';

  @override
  String get accountOperations => 'Account Operations';

  @override
  String get addIncome => 'Add Income';

  @override
  String get unexpectedMoney => 'Got some unexpected money?';

  @override
  String get enterAmount => 'Enter amount';

  @override
  String get buttonAdd => 'Add';

  @override
  String get editTotalBalance => 'Edit Total Balance';

  @override
  String get resetInitialBalance => 'Reset initial balance';

  @override
  String get updateBalance => 'Update Balance';

  @override
  String get buttonUpdate => 'Update';

  @override
  String get areYouSure => 'Are you sure?';

  @override
  String get deleteWarning =>
      'All your expenses, subscriptions, and settings will be permanently deleted.';

  @override
  String get yesContinue => 'Yes, Continue';

  @override
  String get finalConfirmation => 'Final Confirmation';

  @override
  String get pressToClearData => 'Press the button to delete data.';

  @override
  String secondsRemaining(int seconds) {
    return '$seconds seconds...';
  }

  @override
  String get deleteNow => 'DELETE NOW';

  @override
  String get waiting => 'Waiting...';

  @override
  String get insightsTitle => 'Predictive Insights';

  @override
  String get goalUnreachable =>
      'Your current spending rate prevents you from saving. Goal is unreachable!';

  @override
  String goalReachableDesc(int days) {
    return 'At your current spending rate, you will reach your goal in approximately $days days.';
  }

  @override
  String budgetEmptyWarning(int days) {
    return 'Warning: At this spending rate, your budget will run out in $days days!';
  }

  @override
  String get budgetSafe => 'Your budget is safe at the current spending rate.';

  @override
  String get dailyAverageSavings => 'Daily Average Savings';

  @override
  String get accountActions => 'Account Actions';

  @override
  String get addIncomeDesc => 'Did you receive unexpected money?';

  @override
  String get noNoteAttached => 'No note attached';

  @override
  String get categoryDistribution => 'Category Distribution';

  @override
  String get balanceSummary => 'Balance Summary';

  @override
  String get remainingBalanceText => 'Remaining Balance';

  @override
  String categoryBudgetShare(String percentage) {
    return 'Category Share: $percentage%';
  }

  @override
  String get spentAmount => 'Spent';

  @override
  String lastMonthPlus(String diff) {
    return 'Last month: +$diff%';
  }

  @override
  String lastMonthMinus(String diff) {
    return 'Last month: $diff%';
  }

  @override
  String get sameAsLastMonth => 'Same as last month';

  @override
  String get newData => 'New Data';

  @override
  String get obligationWarning =>
      'This is a mandatory expense. It doesn\'t affect your daily limit, only deducted from your main balance.';

  @override
  String get tapForDetails => 'Tap for details';

  @override
  String transactionCount(String count) {
    return '$count Transactions';
  }

  @override
  String get noRecordsToday => 'No records for this day.';

  @override
  String get goalCurrentGoal => 'Current Goal';

  @override
  String get goalTotalSavings => 'Total Savings (In Vault)';

  @override
  String get goalThisMonthTask => 'This Month\'s Task (Protected)';

  @override
  String get goalRemainingNet => 'Remaining Goal';

  @override
  String get goalIfProtected => 'If Protected This Month';

  @override
  String get goalUpdateBtn => 'Update';

  @override
  String get goalAddBtn => 'Add';

  @override
  String get goalBalanceAction => 'Balance Action';

  @override
  String get goalWithdrawMoney => 'Withdraw';

  @override
  String get goalEnterAmountHint => 'Enter amount (e.g. 500)';

  @override
  String get goalWithdrawBtn => 'Withdraw';

  @override
  String get goalSpendingPower => 'Spending Power';

  @override
  String get goalDailyLimit => 'Daily Limit';

  @override
  String get goalOnTarget => 'On Daily Target';

  @override
  String get goalLimitExceeded => 'Limit Exceeded';

  @override
  String get goalEditPlan => 'Edit Financial Plan';

  @override
  String get goalDistributable => 'Distributable';

  @override
  String get goalMonthlyTarget => 'Monthly Target';

  @override
  String get goalDaily => 'Daily';

  @override
  String get goalResetTitle => 'Reset Goal?';

  @override
  String get goalResetDesc =>
      'Are you sure you want to reset your current goal and everything you\'ve saved? This action cannot be undone.';

  @override
  String get goalCancelBtn => 'Cancel';

  @override
  String get goalResetSuccessMsg => 'Goal and savings reset.';

  @override
  String get goalResetBtn => 'Reset';

  @override
  String get goalUpdateGoalTitle => 'Update Goal';

  @override
  String get goalNameInputLabel => 'Item Name';

  @override
  String get goalTargetPrice => 'Target Price';

  @override
  String get goalSaveBtn => 'Save';

  @override
  String get goalUpdateGoalsTitle => 'Update Goals';

  @override
  String get goalMonthlySavingsTarget => 'Monthly Savings Target';

  @override
  String get shadowItemHint => 'e.g. Coffee, headphones...';

  @override
  String get badgeKutsalSeriTitle => 'The Holy Streak';

  @override
  String get badgeKutsalSeriDesc =>
      'Number of consecutive days without spending.';

  @override
  String get badgeCuzdanBekcisiTitle => 'Wallet Guardian';

  @override
  String get badgeCuzdanBekcisiDesc =>
      'Total number of days with exactly zero spending.';

  @override
  String get badgeDuyguDedektifiTitle => 'Emotion Detective';

  @override
  String get badgeDuyguDedektifiDesc =>
      'Total number of logged transactions with an emotion.';

  @override
  String get badgeDuzenUzmaniTitle => 'Balance Expert';

  @override
  String get badgeDuzenUzmaniDesc =>
      'Total number of transactions labeled as need, want, or obligation.';

  @override
  String get badgeVeriKurduTitle => 'Data Nerd';

  @override
  String get badgeVeriKurduDesc =>
      'Total number of expense transactions logged in the system.';

  @override
  String get badgeVazgecisUstasiTitle => 'Master of Letting Go';

  @override
  String get badgeVazgecisUstasiDesc =>
      'Total number of items skipped and sent to the shadow budget.';

  @override
  String get badgeGallery => 'Badge Gallery';

  @override
  String get totalProgress => 'Total Progress';

  @override
  String get totalLevels => 'Total Levels';

  @override
  String get maxShort => 'MAX';

  @override
  String get levelShort => 'LVL';

  @override
  String get streakBadge => '🔥 Streak Badge';

  @override
  String get cumulativeBadge => '📈 Cumulative Badge';

  @override
  String get maxLevelReached => 'MAXIMUM LEVEL REACHED!';

  @override
  String get subscriptionManagement => 'Subscription Management';

  @override
  String get monthlyTotalLabel => 'Monthly Total';

  @override
  String get expenseDistribution => 'Expense Distribution';

  @override
  String get detailsButton => 'Details';

  @override
  String get mySubscriptions => 'My Subscriptions';

  @override
  String onDate(String date) {
    return 'on the $date';
  }

  @override
  String get addNewSubscription => 'Add New Subscription';

  @override
  String get noSubscriptionsAdded =>
      'You haven\'t added any subscriptions yet.';

  @override
  String nextLevelTarget(int count) {
    return 'Target for next level:\nYou need to do $count more.';
  }

  @override
  String progressLabel(int current, int total) {
    return '$current / $total progress';
  }

  @override
  String get monthlyReport => 'Monthly Report';

  @override
  String get totalSpent => 'TOTAL SPENT';

  @override
  String comparedToLastMonth(String percentage, String trend) {
    return '%$percentage $trend than last month';
  }

  @override
  String get trendLess => 'less';

  @override
  String get trendMore => 'more';

  @override
  String get subscriptionDistribution => 'Subscription Distribution';

  @override
  String get upcomingPayments => 'Upcoming Payments';

  @override
  String get noUpcomingPayments => 'No upcoming payments.';

  @override
  String nextPaymentInDays(int days) {
    return 'NEXT UP • $days DAYS LEFT';
  }

  @override
  String get unknown => 'Unknown';

  @override
  String daysRemainingText(int days) {
    return '$days days left';
  }

  @override
  String get editSubscription => 'Edit Subscription';

  @override
  String get newSubscription => 'New Subscription';

  @override
  String get serviceIconLabel => 'SERVICE ICON';

  @override
  String get serviceNameLabel => 'SERVICE NAME';

  @override
  String get serviceNameHint => 'E.g. Netflix, Spotify...';

  @override
  String get monthlyFeeLabel => 'MONTHLY FEE';

  @override
  String get paymentCycleLabel => 'PAYMENT CYCLE';

  @override
  String get wantNeedLabel => 'WANT / NEED';

  @override
  String get needItem => 'Need';

  @override
  String get wantItem => 'Want';

  @override
  String get necessityItem => 'Necessity';

  @override
  String get moodLabel => 'MOOD';

  @override
  String get happyItem => 'Happy';

  @override
  String get neutralItem => 'Neutral';

  @override
  String get regretItem => 'Regret';

  @override
  String get nextPaymentDateLabel => 'NEXT PAYMENT DATE';

  @override
  String get dateHint => 'dd.mm.yyyy';

  @override
  String get unnamed => 'Unnamed';

  @override
  String get notSpecified => 'Not specified';

  @override
  String get saveChanges => 'SAVE CHANGES';

  @override
  String get saveSubscription => 'SAVE SUBSCRIPTION';

  @override
  String get deleteSubscription => 'DELETE SUBSCRIPTION';

  @override
  String get editMyIcon => 'Edit My Icon';

  @override
  String get customIcon => 'Custom Icon';

  @override
  String get selectIconTitle => 'Select Icon';

  @override
  String get uploadIcon => 'UPLOAD ICON';

  @override
  String get popularCategory => 'Popular';

  @override
  String get financeCategory => 'Finance';

  @override
  String get educationCategory => 'Education';

  @override
  String get entertainmentCategory => 'Entertainment';

  @override
  String get bankWord => 'Bank';

  @override
  String get insuranceWord => 'Insurance';

  @override
  String get creditCardWord => 'Credit Card';

  @override
  String get creditWord => 'Loan/Credit';

  @override
  String get schoolWord => 'School';

  @override
  String get bookMagazineWord => 'Book/Magazine';

  @override
  String get personalDevWord => 'Personal Dev';

  @override
  String get courseWord => 'Course';

  @override
  String get gameWord => 'Game';

  @override
  String get cinemaSeriesWord => 'Cinema/Series';

  @override
  String get musicWord => 'Music';

  @override
  String get eventActivityWord => 'Event';

  @override
  String get totalUppercase => 'TOTAL';

  @override
  String get spendingsTab => 'Spendings';

  @override
  String get otherCategory => 'Other';

  @override
  String get autoRenewal => 'Auto Renewal';

  @override
  String get appPurposeHeroTitle => 'Conscious Spending,\nFree Future.';

  @override
  String get appPurposeHeroDesc =>
      'Pretio transforms your expenses from mere numbers into their true impact on your life, helping you replace impulsive urges with conscious decisions that lead you to your dreams.';

  @override
  String get feature1Title => 'Fast and Practical Logging';

  @override
  String get feature1Desc =>
      'Log your expenses instantly and effortlessly. Instead of tedious forms, add your transactions in seconds, turning financial tracking into a pleasant daily habit.';

  @override
  String get feature2Title => 'Emotional Finance Compass';

  @override
  String get feature2Desc =>
      'Discover the psychology behind every expense. Is it a real need or a sudden urge? Map your consumption habits and allocate your money only to things that bring you value.';

  @override
  String get feature3Title => 'Focus on Your Dreams';

  @override
  String get feature3Desc =>
      'Plan not just for today, but for the future. Clearly see how close you are to your dream goal and direct your savings straight towards it.';

  @override
  String get feature4Title => 'Detailed Analytics and Habit Tracking';

  @override
  String get feature4Desc =>
      'See transparently where your money goes. Discover your consumption habits by examining your spending trends and emotional distribution in detail with elegant charts.';

  @override
  String get feature5Title => 'Fully Customizable';

  @override
  String get feature5Desc =>
      'Tailor your financial assistant to your lifestyle. Create your own categories, set your quick entry amounts, and celebrate your achievements with unique badges.';

  @override
  String get aboutHeroDesc =>
      'Pretio isn\'t just an ordinary budget tracker; it\'s a personal life philosophy that gives you back control over your time, money, and emotions. Amidst the frenzy of consumerism, it is designed to remind you of your own willpower and illuminate the path to your dreams.';

  @override
  String get aboutSection1Title => 'Meaning of the Name';

  @override
  String get aboutSection1Desc =>
      'Pretio derives its roots from the Latin word \"pretium\", meaning \"value\", \"worth\", and \"price\". Everything we buy in life comes not just at a financial cost, but at a true price paid with our time and emotions. Pretio exists to show you this true value.';

  @override
  String get aboutSection2Title => 'Its Simplicity';

  @override
  String get aboutSection2Desc =>
      'It doesn\'t overwhelm you with complex financial tables, confusing menus, and exhausting charts. With its easy-on-the-eyes, minimalist design, it turns financial tracking from a source of stress into a peaceful daily routine.';

  @override
  String get aboutSection3Title => 'Its Awareness';

  @override
  String get aboutSection3Desc =>
      'It shows you not just what you spend, but why you spend it. Illuminating your consumption psychology, it helps you understand whether the item you bought is a genuine need or a momentary whim.';

  @override
  String get aboutSection4Title => 'Its Practicality';

  @override
  String get aboutSection4Desc =>
      'It perfectly keeps up with the pace of daily life. You can log expenses in seconds without filling out long and tedious forms, update your budget with a single touch, and summarize your financial status at a glance.';

  @override
  String get aboutSection5Title => 'Its Customizability';

  @override
  String get aboutSection5Desc =>
      'Everyone\'s lifestyle and financial journey is unique to them. You can fully tailor Pretio to your own habits by creating your own spending categories, setting personalized goals, and adjusting your quick entry amounts.';

  @override
  String get aboutFooterNote =>
      'This app was brought to life by an independent group of developers to help you protect your own willpower against the frenzy of consumerism.';

  @override
  String get developersTitle => 'Our Developers';

  @override
  String get averageSoFar => 'Average so far';

  @override
  String get all => 'All';

  @override
  String get favorites => 'Favorites';

  @override
  String get currentNetBalance => 'Current Net Balance';

  @override
  String get makeTransaction => 'Make Transaction';

  @override
  String get expense => 'Expense';

  @override
  String get income => 'Income';

  @override
  String insightProjectionGood(String percent) {
    return 'At this rate, you will save $percent% more than your target by month end.';
  }

  @override
  String insightProjectionBad(String percent) {
    return 'At this rate, you will save $percent% less than your target by month end.';
  }

  @override
  String insightCategoryAlert(String category) {
    return 'You spent the most in the $category category this month.';
  }

  @override
  String insightStreak(int days) {
    return 'Great! You haven\'t spent anything for $days days.';
  }
}

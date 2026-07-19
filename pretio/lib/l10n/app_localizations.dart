import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_tr.dart';

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
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('tr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Time Cost Calculator'**
  String get appTitle;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @coach.
  ///
  /// In en, this message translates to:
  /// **'Coach'**
  String get coach;

  /// No description provided for @shadow.
  ///
  /// In en, this message translates to:
  /// **'Shadow'**
  String get shadow;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @setDailyGoal.
  ///
  /// In en, this message translates to:
  /// **'Set Daily Goal'**
  String get setDailyGoal;

  /// No description provided for @addQuickAmount.
  ///
  /// In en, this message translates to:
  /// **'Add Quick Amount'**
  String get addQuickAmount;

  /// No description provided for @needs.
  ///
  /// In en, this message translates to:
  /// **'Needs'**
  String get needs;

  /// No description provided for @wants.
  ///
  /// In en, this message translates to:
  /// **'Wants'**
  String get wants;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @currentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get currentStreak;

  /// No description provided for @longestStreak.
  ///
  /// In en, this message translates to:
  /// **'Longest Streak'**
  String get longestStreak;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @editAmount.
  ///
  /// In en, this message translates to:
  /// **'Edit Amount {amount}'**
  String editAmount(double amount);

  /// No description provided for @deleteAmountConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete this quick amount?'**
  String get deleteAmountConfirmation;

  /// No description provided for @manage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manage;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @addTransaction.
  ///
  /// In en, this message translates to:
  /// **'Add transaction'**
  String get addTransaction;

  /// No description provided for @whatDidYouBuy.
  ///
  /// In en, this message translates to:
  /// **'What did you buy?'**
  String get whatDidYouBuy;

  /// No description provided for @howDoYouFeel.
  ///
  /// In en, this message translates to:
  /// **'How do you feel about this?'**
  String get howDoYouFeel;

  /// No description provided for @isThisNeedOrWant.
  ///
  /// In en, this message translates to:
  /// **'Is this a Need, Want or Necessity?'**
  String get isThisNeedOrWant;

  /// No description provided for @saveTransaction.
  ///
  /// In en, this message translates to:
  /// **'Save Transaction'**
  String get saveTransaction;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @noRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'No recent activity'**
  String get noRecentActivity;

  /// No description provided for @newCategory.
  ///
  /// In en, this message translates to:
  /// **'New Category'**
  String get newCategory;

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Category Name'**
  String get categoryName;

  /// No description provided for @selectIcon.
  ///
  /// In en, this message translates to:
  /// **'Select Icon'**
  String get selectIcon;

  /// No description provided for @selectColor.
  ///
  /// In en, this message translates to:
  /// **'Select Color'**
  String get selectColor;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @shadowBudget.
  ///
  /// In en, this message translates to:
  /// **'Shadow Budget'**
  String get shadowBudget;

  /// No description provided for @item.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get item;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @howDidItFeel.
  ///
  /// In en, this message translates to:
  /// **'How did it feel not buying it?'**
  String get howDidItFeel;

  /// No description provided for @proud.
  ///
  /// In en, this message translates to:
  /// **'Proud'**
  String get proud;

  /// No description provided for @relieved.
  ///
  /// In en, this message translates to:
  /// **'Relieved'**
  String get relieved;

  /// No description provided for @sad.
  ///
  /// In en, this message translates to:
  /// **'Sad'**
  String get sad;

  /// No description provided for @iDidntBuyIt.
  ///
  /// In en, this message translates to:
  /// **'I Didn\'t Buy It!'**
  String get iDidntBuyIt;

  /// No description provided for @totalSaved.
  ///
  /// In en, this message translates to:
  /// **'Total Saved: {amount}'**
  String totalSaved(double amount);

  /// No description provided for @examples.
  ///
  /// In en, this message translates to:
  /// **'EXAMPLES'**
  String get examples;

  /// No description provided for @memberSince.
  ///
  /// In en, this message translates to:
  /// **'Member since {year}'**
  String memberSince(int year);

  /// No description provided for @financialHealth.
  ///
  /// In en, this message translates to:
  /// **'Financial Health'**
  String get financialHealth;

  /// No description provided for @excellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get excellent;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @annualSalary.
  ///
  /// In en, this message translates to:
  /// **'Annual Salary'**
  String get annualSalary;

  /// No description provided for @weeklyHours.
  ///
  /// In en, this message translates to:
  /// **'Weekly Hours'**
  String get weeklyHours;

  /// No description provided for @appPreferences.
  ///
  /// In en, this message translates to:
  /// **'App Preferences'**
  String get appPreferences;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @faceIdLogin.
  ///
  /// In en, this message translates to:
  /// **'FaceID Login'**
  String get faceIdLogin;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @timeValue.
  ///
  /// In en, this message translates to:
  /// **'Time Value'**
  String get timeValue;

  /// No description provided for @yourProfileShared.
  ///
  /// In en, this message translates to:
  /// **'YOUR PROFILE (Shared)'**
  String get yourProfileShared;

  /// No description provided for @monthlySalary.
  ///
  /// In en, this message translates to:
  /// **'Monthly Salary'**
  String get monthlySalary;

  /// No description provided for @recalculateRate.
  ///
  /// In en, this message translates to:
  /// **'Recalculate Rate'**
  String get recalculateRate;

  /// No description provided for @yourTimeIsWorth.
  ///
  /// In en, this message translates to:
  /// **'Your time is worth'**
  String get yourTimeIsWorth;

  /// No description provided for @tlPhr.
  ///
  /// In en, this message translates to:
  /// **'/hr'**
  String get tlPhr;

  /// No description provided for @howMuchLife.
  ///
  /// In en, this message translates to:
  /// **'HOW MUCH LIFE DOES IT COST?'**
  String get howMuchLife;

  /// No description provided for @trends.
  ///
  /// In en, this message translates to:
  /// **'Trends'**
  String get trends;

  /// No description provided for @noTransactionsYet.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet.'**
  String get noTransactionsYet;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @okay.
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get okay;

  /// No description provided for @regret.
  ///
  /// In en, this message translates to:
  /// **'Regret'**
  String get regret;

  /// No description provided for @overBudget.
  ///
  /// In en, this message translates to:
  /// **'Over Budget'**
  String get overBudget;

  /// No description provided for @onTrack.
  ///
  /// In en, this message translates to:
  /// **'On Track'**
  String get onTrack;

  /// No description provided for @monthlyAvg.
  ///
  /// In en, this message translates to:
  /// **'MONTHLY AVG'**
  String get monthlyAvg;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @perDay.
  ///
  /// In en, this message translates to:
  /// **'/ day'**
  String get perDay;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'{count} Days'**
  String days(int count);

  /// No description provided for @financialCoach.
  ///
  /// In en, this message translates to:
  /// **'Financial Coach'**
  String get financialCoach;

  /// No description provided for @moodVsMoney.
  ///
  /// In en, this message translates to:
  /// **'Mood vs. Money'**
  String get moodVsMoney;

  /// No description provided for @needVsWant.
  ///
  /// In en, this message translates to:
  /// **'Need vs. Want'**
  String get needVsWant;

  /// No description provided for @deleteCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{category}\"?'**
  String deleteCategoryTitle(String category);

  /// No description provided for @deleteCategoryContent.
  ///
  /// In en, this message translates to:
  /// **'This will only remove the category from your list. Existing transactions will keep this category name.'**
  String get deleteCategoryContent;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @goal.
  ///
  /// In en, this message translates to:
  /// **'GOAL: {amount}'**
  String goal(double amount);

  /// No description provided for @transactionHistory.
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get transactionHistory;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @editTransactionTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Transaction'**
  String get editTransactionTitle;

  /// No description provided for @titleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titleLabel;

  /// No description provided for @amountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amountLabel;

  /// No description provided for @favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favorite;

  /// No description provided for @need.
  ///
  /// In en, this message translates to:
  /// **'Need'**
  String get need;

  /// No description provided for @want.
  ///
  /// In en, this message translates to:
  /// **'Want'**
  String get want;

  /// No description provided for @necessity.
  ///
  /// In en, this message translates to:
  /// **'Necessity'**
  String get necessity;

  /// No description provided for @spendingBalance.
  ///
  /// In en, this message translates to:
  /// **'Spending Balance'**
  String get spendingBalance;

  /// No description provided for @emotionalImpact.
  ///
  /// In en, this message translates to:
  /// **'Emotional Impact'**
  String get emotionalImpact;

  /// No description provided for @budgetProgress.
  ///
  /// In en, this message translates to:
  /// **'Budget Progress'**
  String get budgetProgress;

  /// No description provided for @weeklyLimit.
  ///
  /// In en, this message translates to:
  /// **'Weekly Limit'**
  String get weeklyLimit;

  /// No description provided for @monthlyLimit.
  ///
  /// In en, this message translates to:
  /// **'Monthly Limit'**
  String get monthlyLimit;

  /// No description provided for @underDailyGoal.
  ///
  /// In en, this message translates to:
  /// **'under daily goal'**
  String get underDailyGoal;

  /// No description provided for @overDailyGoal.
  ///
  /// In en, this message translates to:
  /// **'over daily goal'**
  String get overDailyGoal;

  /// No description provided for @fancyLatte.
  ///
  /// In en, this message translates to:
  /// **'Fancy Latte'**
  String get fancyLatte;

  /// No description provided for @runningShoes.
  ///
  /// In en, this message translates to:
  /// **'Running Shoes'**
  String get runningShoes;

  /// No description provided for @flagshipPhone.
  ///
  /// In en, this message translates to:
  /// **'Flagship Phone'**
  String get flagshipPhone;

  /// No description provided for @sedanCar.
  ///
  /// In en, this message translates to:
  /// **'Sedan Car'**
  String get sedanCar;

  /// No description provided for @catFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get catFood;

  /// No description provided for @catTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get catTransport;

  /// No description provided for @catShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get catShopping;

  /// No description provided for @catFun.
  ///
  /// In en, this message translates to:
  /// **'Fun'**
  String get catFun;

  /// No description provided for @catBills.
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get catBills;

  /// No description provided for @catOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get catOther;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @undoTransactionQuestion.
  ///
  /// In en, this message translates to:
  /// **'Do you want to undo this transaction?'**
  String get undoTransactionQuestion;

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

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add Note'**
  String get addNote;

  /// No description provided for @enterNote.
  ///
  /// In en, this message translates to:
  /// **'Enter note here...'**
  String get enterNote;

  /// No description provided for @budgetPlanner.
  ///
  /// In en, this message translates to:
  /// **'Budget Planner'**
  String get budgetPlanner;

  /// No description provided for @pleaseEnterItemAndPrice.
  ///
  /// In en, this message translates to:
  /// **'Please enter item and price'**
  String get pleaseEnterItemAndPrice;

  /// No description provided for @victorySaved.
  ///
  /// In en, this message translates to:
  /// **'Victory Saved! 🎉'**
  String get victorySaved;

  /// No description provided for @editGoal.
  ///
  /// In en, this message translates to:
  /// **'Edit Goal'**
  String get editGoal;

  /// No description provided for @goalName.
  ///
  /// In en, this message translates to:
  /// **'Goal Name'**
  String get goalName;

  /// No description provided for @goalAmount.
  ///
  /// In en, this message translates to:
  /// **'Goal Amount'**
  String get goalAmount;

  /// No description provided for @rateUpdated.
  ///
  /// In en, this message translates to:
  /// **'Rate Updated! 🚀'**
  String get rateUpdated;

  /// No description provided for @coffeeShoesEta.
  ///
  /// In en, this message translates to:
  /// **'Coffee, Shoes etc.'**
  String get coffeeShoesEta;

  /// No description provided for @howMuchWasIt.
  ///
  /// In en, this message translates to:
  /// **'How much was it?'**
  String get howMuchWasIt;

  /// No description provided for @happy.
  ///
  /// In en, this message translates to:
  /// **'Happy'**
  String get happy;

  /// No description provided for @neutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get neutral;

  /// No description provided for @reclaimed.
  ///
  /// In en, this message translates to:
  /// **'RECLAIMED'**
  String get reclaimed;

  /// No description provided for @workHours.
  ///
  /// In en, this message translates to:
  /// **'Work Hours'**
  String get workHours;

  /// No description provided for @mountainOfSavings.
  ///
  /// In en, this message translates to:
  /// **'Mountain of Savings'**
  String get mountainOfSavings;

  /// No description provided for @levelX.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String levelX(int level);

  /// No description provided for @starting.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get starting;

  /// No description provided for @totalPool.
  ///
  /// In en, this message translates to:
  /// **'Total Pool'**
  String get totalPool;

  /// No description provided for @discretionarySpending.
  ///
  /// In en, this message translates to:
  /// **'Discretionary'**
  String get discretionarySpending;

  /// No description provided for @leftToPeak.
  ///
  /// In en, this message translates to:
  /// **'{percent}% left to peak'**
  String leftToPeak(int percent);

  /// No description provided for @recentVictories.
  ///
  /// In en, this message translates to:
  /// **'Recent Victories'**
  String get recentVictories;

  /// No description provided for @noVictoriesYet.
  ///
  /// In en, this message translates to:
  /// **'No victories recorded yet.'**
  String get noVictoriesYet;

  /// No description provided for @savedHours.
  ///
  /// In en, this message translates to:
  /// **'{hours} hours reclaimed'**
  String savedHours(String hours);

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @editVictory.
  ///
  /// In en, this message translates to:
  /// **'Edit Victory'**
  String get editVictory;

  /// No description provided for @minShort.
  ///
  /// In en, this message translates to:
  /// **'m'**
  String get minShort;

  /// No description provided for @hrShort.
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get hrShort;

  /// No description provided for @workDay.
  ///
  /// In en, this message translates to:
  /// **'work day'**
  String get workDay;

  /// No description provided for @monthShort.
  ///
  /// In en, this message translates to:
  /// **'month'**
  String get monthShort;

  /// No description provided for @workShort.
  ///
  /// In en, this message translates to:
  /// **'work'**
  String get workShort;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @goals.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get goals;

  /// No description provided for @noSpendToast.
  ///
  /// In en, this message translates to:
  /// **'Spending recorded today!'**
  String get noSpendToast;

  /// No description provided for @noSpendTitle.
  ///
  /// In en, this message translates to:
  /// **'No spending'**
  String get noSpendTitle;

  /// No description provided for @noSpendNote.
  ///
  /// In en, this message translates to:
  /// **'No spending was done today'**
  String get noSpendNote;

  /// No description provided for @deletedData.
  ///
  /// In en, this message translates to:
  /// **'Deleted Data'**
  String get deletedData;

  /// No description provided for @settingsAndPreferences.
  ///
  /// In en, this message translates to:
  /// **'SETTINGS AND PREFERENCES'**
  String get settingsAndPreferences;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @profileNameLabel.
  ///
  /// In en, this message translates to:
  /// **'PROFILE NAME'**
  String get profileNameLabel;

  /// No description provided for @avatarLabel.
  ///
  /// In en, this message translates to:
  /// **'AVATAR'**
  String get avatarLabel;

  /// No description provided for @personalizeCharacter.
  ///
  /// In en, this message translates to:
  /// **'Personalize your character'**
  String get personalizeCharacter;

  /// No description provided for @changeAvatar.
  ///
  /// In en, this message translates to:
  /// **'CHANGE AVATAR'**
  String get changeAvatar;

  /// No description provided for @balanceAndFinance.
  ///
  /// In en, this message translates to:
  /// **'Balance and Finance'**
  String get balanceAndFinance;

  /// No description provided for @balanceInfoLabel.
  ///
  /// In en, this message translates to:
  /// **'BALANCE INFO'**
  String get balanceInfoLabel;

  /// No description provided for @currentBalance.
  ///
  /// In en, this message translates to:
  /// **'CURRENT: {amount}'**
  String currentBalance(String amount);

  /// No description provided for @currencyLabel.
  ///
  /// In en, this message translates to:
  /// **'CURRENCY'**
  String get currencyLabel;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @languageSelectionLabel.
  ///
  /// In en, this message translates to:
  /// **'LANGUAGE SELECTION'**
  String get languageSelectionLabel;

  /// No description provided for @themesLabel.
  ///
  /// In en, this message translates to:
  /// **'THEMES'**
  String get themesLabel;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeForest.
  ///
  /// In en, this message translates to:
  /// **'Forest Green'**
  String get themeForest;

  /// No description provided for @themeCottonCandy.
  ///
  /// In en, this message translates to:
  /// **'Cotton Candy'**
  String get themeCottonCandy;

  /// No description provided for @themeSunset.
  ///
  /// In en, this message translates to:
  /// **'Sunset'**
  String get themeSunset;

  /// No description provided for @themeProfileDark.
  ///
  /// In en, this message translates to:
  /// **'Night Blue'**
  String get themeProfileDark;

  /// No description provided for @themeAmoled.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeAmoled;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @hideSpentMoney.
  ///
  /// In en, this message translates to:
  /// **'HIDE SPENT MONEY'**
  String get hideSpentMoney;

  /// No description provided for @privacyMode.
  ///
  /// In en, this message translates to:
  /// **'Privacy mode'**
  String get privacyMode;

  /// No description provided for @needWantModule.
  ///
  /// In en, this message translates to:
  /// **'NEED - WANT MODULE'**
  String get needWantModule;

  /// No description provided for @showWhenAddingNew.
  ///
  /// In en, this message translates to:
  /// **'Show when adding new transaction'**
  String get showWhenAddingNew;

  /// No description provided for @emotionModule.
  ///
  /// In en, this message translates to:
  /// **'EMOTION MODULE'**
  String get emotionModule;

  /// No description provided for @view3D.
  ///
  /// In en, this message translates to:
  /// **'3D VIEW'**
  String get view3D;

  /// No description provided for @addEmbossEffect.
  ///
  /// In en, this message translates to:
  /// **'Add emboss effect to cards'**
  String get addEmbossEffect;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @deleteAll.
  ///
  /// In en, this message translates to:
  /// **'DELETE EVERYTHING'**
  String get deleteAll;

  /// No description provided for @deletePermanently.
  ///
  /// In en, this message translates to:
  /// **'Delete all data permanently'**
  String get deletePermanently;

  /// No description provided for @buttonDelete.
  ///
  /// In en, this message translates to:
  /// **'DELETE'**
  String get buttonDelete;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @appPurpose.
  ///
  /// In en, this message translates to:
  /// **'APP PURPOSE'**
  String get appPurpose;

  /// No description provided for @whyAreWeHere.
  ///
  /// In en, this message translates to:
  /// **'Why are we here?'**
  String get whyAreWeHere;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'ABOUT APP'**
  String get aboutApp;

  /// No description provided for @versionAndDetails.
  ///
  /// In en, this message translates to:
  /// **'Version and details'**
  String get versionAndDetails;

  /// No description provided for @creators.
  ///
  /// In en, this message translates to:
  /// **'CREATORS'**
  String get creators;

  /// No description provided for @whoDevelopedIt.
  ///
  /// In en, this message translates to:
  /// **'Who developed it?'**
  String get whoDevelopedIt;

  /// No description provided for @selectAvatar.
  ///
  /// In en, this message translates to:
  /// **'Select Avatar'**
  String get selectAvatar;

  /// No description provided for @editPhoto.
  ///
  /// In en, this message translates to:
  /// **'Edit Photo'**
  String get editPhoto;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @highestStreak.
  ///
  /// In en, this message translates to:
  /// **'HIGHEST STREAK'**
  String get highestStreak;

  /// No description provided for @totalSpending.
  ///
  /// In en, this message translates to:
  /// **'TOTAL SPENDING'**
  String get totalSpending;

  /// No description provided for @currentStreakLabel.
  ///
  /// In en, this message translates to:
  /// **'CURRENT STREAK'**
  String get currentStreakLabel;

  /// No description provided for @financialIq.
  ///
  /// In en, this message translates to:
  /// **'Financial IQ'**
  String get financialIq;

  /// No description provided for @percentNeed.
  ///
  /// In en, this message translates to:
  /// **'{percent}% Need'**
  String percentNeed(int percent);

  /// No description provided for @percentWant.
  ///
  /// In en, this message translates to:
  /// **'{percent}% Want'**
  String percentWant(int percent);

  /// No description provided for @percentObligation.
  ///
  /// In en, this message translates to:
  /// **'{percent}% Oblig.'**
  String percentObligation(int percent);

  /// No description provided for @subscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get subscriptions;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'SEE ALL'**
  String get seeAll;

  /// No description provided for @noSubscriptionsYet.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t added any subscriptions yet.'**
  String get noSubscriptionsYet;

  /// No description provided for @badgesAndAchievements.
  ///
  /// In en, this message translates to:
  /// **'Badges & Achievements'**
  String get badgesAndAchievements;

  /// No description provided for @accountOperations.
  ///
  /// In en, this message translates to:
  /// **'Account Operations'**
  String get accountOperations;

  /// No description provided for @addIncome.
  ///
  /// In en, this message translates to:
  /// **'Add Income'**
  String get addIncome;

  /// No description provided for @unexpectedMoney.
  ///
  /// In en, this message translates to:
  /// **'Got some unexpected money?'**
  String get unexpectedMoney;

  /// No description provided for @enterAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter amount'**
  String get enterAmount;

  /// No description provided for @buttonAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get buttonAdd;

  /// No description provided for @editTotalBalance.
  ///
  /// In en, this message translates to:
  /// **'Edit Total Balance'**
  String get editTotalBalance;

  /// No description provided for @resetInitialBalance.
  ///
  /// In en, this message translates to:
  /// **'Reset initial balance'**
  String get resetInitialBalance;

  /// No description provided for @updateBalance.
  ///
  /// In en, this message translates to:
  /// **'Update Balance'**
  String get updateBalance;

  /// No description provided for @buttonUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get buttonUpdate;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// No description provided for @deleteWarning.
  ///
  /// In en, this message translates to:
  /// **'All your expenses, subscriptions, and settings will be permanently deleted.'**
  String get deleteWarning;

  /// No description provided for @yesContinue.
  ///
  /// In en, this message translates to:
  /// **'Yes, Continue'**
  String get yesContinue;

  /// No description provided for @finalConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Final Confirmation'**
  String get finalConfirmation;

  /// No description provided for @pressToClearData.
  ///
  /// In en, this message translates to:
  /// **'Press the button to delete data.'**
  String get pressToClearData;

  /// No description provided for @secondsRemaining.
  ///
  /// In en, this message translates to:
  /// **'{seconds} seconds...'**
  String secondsRemaining(int seconds);

  /// No description provided for @deleteNow.
  ///
  /// In en, this message translates to:
  /// **'DELETE NOW'**
  String get deleteNow;

  /// No description provided for @waiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting...'**
  String get waiting;

  /// No description provided for @insightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Predictive Insights'**
  String get insightsTitle;

  /// No description provided for @goalUnreachable.
  ///
  /// In en, this message translates to:
  /// **'Your current spending rate prevents you from saving. Goal is unreachable!'**
  String get goalUnreachable;

  /// No description provided for @goalReachableDesc.
  ///
  /// In en, this message translates to:
  /// **'At your current spending rate, you will reach your goal in approximately {days} days.'**
  String goalReachableDesc(int days);

  /// No description provided for @budgetEmptyWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning: At this spending rate, your budget will run out in {days} days!'**
  String budgetEmptyWarning(int days);

  /// No description provided for @budgetSafe.
  ///
  /// In en, this message translates to:
  /// **'Your budget is safe at the current spending rate.'**
  String get budgetSafe;

  /// No description provided for @dailyAverageSavings.
  ///
  /// In en, this message translates to:
  /// **'Daily Average Savings'**
  String get dailyAverageSavings;

  /// No description provided for @accountActions.
  ///
  /// In en, this message translates to:
  /// **'Account Actions'**
  String get accountActions;

  /// No description provided for @addIncomeDesc.
  ///
  /// In en, this message translates to:
  /// **'Did you receive unexpected money?'**
  String get addIncomeDesc;

  /// No description provided for @noNoteAttached.
  ///
  /// In en, this message translates to:
  /// **'No note attached'**
  String get noNoteAttached;

  /// No description provided for @categoryDistribution.
  ///
  /// In en, this message translates to:
  /// **'Category Distribution'**
  String get categoryDistribution;

  /// No description provided for @balanceSummary.
  ///
  /// In en, this message translates to:
  /// **'Balance Summary'**
  String get balanceSummary;

  /// No description provided for @remainingBalanceText.
  ///
  /// In en, this message translates to:
  /// **'Remaining Balance'**
  String get remainingBalanceText;

  /// No description provided for @categoryBudgetShare.
  ///
  /// In en, this message translates to:
  /// **'Category Share: {percentage}%'**
  String categoryBudgetShare(String percentage);

  /// No description provided for @spentAmount.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get spentAmount;

  /// No description provided for @lastMonthPlus.
  ///
  /// In en, this message translates to:
  /// **'Last month: +{diff}%'**
  String lastMonthPlus(String diff);

  /// No description provided for @lastMonthMinus.
  ///
  /// In en, this message translates to:
  /// **'Last month: {diff}%'**
  String lastMonthMinus(String diff);

  /// No description provided for @sameAsLastMonth.
  ///
  /// In en, this message translates to:
  /// **'Same as last month'**
  String get sameAsLastMonth;

  /// No description provided for @newData.
  ///
  /// In en, this message translates to:
  /// **'New Data'**
  String get newData;

  /// No description provided for @obligationWarning.
  ///
  /// In en, this message translates to:
  /// **'This is a mandatory expense. It doesn\'t affect your daily limit, only deducted from your main balance.'**
  String get obligationWarning;

  /// No description provided for @tapForDetails.
  ///
  /// In en, this message translates to:
  /// **'Tap for details'**
  String get tapForDetails;

  /// No description provided for @transactionCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Transactions'**
  String transactionCount(String count);

  /// No description provided for @noRecordsToday.
  ///
  /// In en, this message translates to:
  /// **'No records for this day.'**
  String get noRecordsToday;

  /// No description provided for @goalCurrentGoal.
  ///
  /// In en, this message translates to:
  /// **'Current Goal'**
  String get goalCurrentGoal;

  /// No description provided for @goalTotalSavings.
  ///
  /// In en, this message translates to:
  /// **'Total Savings (In Vault)'**
  String get goalTotalSavings;

  /// No description provided for @goalThisMonthTask.
  ///
  /// In en, this message translates to:
  /// **'This Month\'s Task (Protected)'**
  String get goalThisMonthTask;

  /// No description provided for @goalRemainingNet.
  ///
  /// In en, this message translates to:
  /// **'Remaining Goal'**
  String get goalRemainingNet;

  /// No description provided for @goalIfProtected.
  ///
  /// In en, this message translates to:
  /// **'If Protected This Month'**
  String get goalIfProtected;

  /// No description provided for @goalUpdateBtn.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get goalUpdateBtn;

  /// No description provided for @goalAddBtn.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get goalAddBtn;

  /// No description provided for @goalBalanceAction.
  ///
  /// In en, this message translates to:
  /// **'Balance Action'**
  String get goalBalanceAction;

  /// No description provided for @goalWithdrawMoney.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get goalWithdrawMoney;

  /// No description provided for @goalEnterAmountHint.
  ///
  /// In en, this message translates to:
  /// **'Enter amount (e.g. 500)'**
  String get goalEnterAmountHint;

  /// No description provided for @goalWithdrawBtn.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get goalWithdrawBtn;

  /// No description provided for @goalSpendingPower.
  ///
  /// In en, this message translates to:
  /// **'Spending Power'**
  String get goalSpendingPower;

  /// No description provided for @goalDailyLimit.
  ///
  /// In en, this message translates to:
  /// **'Daily Limit'**
  String get goalDailyLimit;

  /// No description provided for @goalOnTarget.
  ///
  /// In en, this message translates to:
  /// **'On Daily Target'**
  String get goalOnTarget;

  /// No description provided for @goalLimitExceeded.
  ///
  /// In en, this message translates to:
  /// **'Limit Exceeded'**
  String get goalLimitExceeded;

  /// No description provided for @goalEditPlan.
  ///
  /// In en, this message translates to:
  /// **'Edit Financial Plan'**
  String get goalEditPlan;

  /// No description provided for @goalDistributable.
  ///
  /// In en, this message translates to:
  /// **'Distributable'**
  String get goalDistributable;

  /// No description provided for @goalMonthlyTarget.
  ///
  /// In en, this message translates to:
  /// **'Monthly Target'**
  String get goalMonthlyTarget;

  /// No description provided for @goalDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get goalDaily;

  /// No description provided for @goalResetTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Goal?'**
  String get goalResetTitle;

  /// No description provided for @goalResetDesc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset your current goal and everything you\'ve saved? This action cannot be undone.'**
  String get goalResetDesc;

  /// No description provided for @goalCancelBtn.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get goalCancelBtn;

  /// No description provided for @goalResetSuccessMsg.
  ///
  /// In en, this message translates to:
  /// **'Goal and savings reset.'**
  String get goalResetSuccessMsg;

  /// No description provided for @goalResetBtn.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get goalResetBtn;

  /// No description provided for @goalUpdateGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Goal'**
  String get goalUpdateGoalTitle;

  /// No description provided for @goalNameInputLabel.
  ///
  /// In en, this message translates to:
  /// **'Item Name'**
  String get goalNameInputLabel;

  /// No description provided for @goalTargetPrice.
  ///
  /// In en, this message translates to:
  /// **'Target Price'**
  String get goalTargetPrice;

  /// No description provided for @goalSaveBtn.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get goalSaveBtn;

  /// No description provided for @goalUpdateGoalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Goals'**
  String get goalUpdateGoalsTitle;

  /// No description provided for @goalMonthlySavingsTarget.
  ///
  /// In en, this message translates to:
  /// **'Monthly Savings Target'**
  String get goalMonthlySavingsTarget;

  /// No description provided for @shadowItemHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Coffee, headphones...'**
  String get shadowItemHint;

  /// No description provided for @badgeKutsalSeriTitle.
  ///
  /// In en, this message translates to:
  /// **'The Holy Streak'**
  String get badgeKutsalSeriTitle;

  /// No description provided for @badgeKutsalSeriDesc.
  ///
  /// In en, this message translates to:
  /// **'Number of consecutive days without spending.'**
  String get badgeKutsalSeriDesc;

  /// No description provided for @badgeCuzdanBekcisiTitle.
  ///
  /// In en, this message translates to:
  /// **'Wallet Guardian'**
  String get badgeCuzdanBekcisiTitle;

  /// No description provided for @badgeCuzdanBekcisiDesc.
  ///
  /// In en, this message translates to:
  /// **'Total number of days with exactly zero spending.'**
  String get badgeCuzdanBekcisiDesc;

  /// No description provided for @badgeDuyguDedektifiTitle.
  ///
  /// In en, this message translates to:
  /// **'Emotion Detective'**
  String get badgeDuyguDedektifiTitle;

  /// No description provided for @badgeDuyguDedektifiDesc.
  ///
  /// In en, this message translates to:
  /// **'Total number of logged transactions with an emotion.'**
  String get badgeDuyguDedektifiDesc;

  /// No description provided for @badgeDuzenUzmaniTitle.
  ///
  /// In en, this message translates to:
  /// **'Balance Expert'**
  String get badgeDuzenUzmaniTitle;

  /// No description provided for @badgeDuzenUzmaniDesc.
  ///
  /// In en, this message translates to:
  /// **'Total number of transactions labeled as need, want, or obligation.'**
  String get badgeDuzenUzmaniDesc;

  /// No description provided for @badgeVeriKurduTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Nerd'**
  String get badgeVeriKurduTitle;

  /// No description provided for @badgeVeriKurduDesc.
  ///
  /// In en, this message translates to:
  /// **'Total number of expense transactions logged in the system.'**
  String get badgeVeriKurduDesc;

  /// No description provided for @badgeVazgecisUstasiTitle.
  ///
  /// In en, this message translates to:
  /// **'Master of Letting Go'**
  String get badgeVazgecisUstasiTitle;

  /// No description provided for @badgeVazgecisUstasiDesc.
  ///
  /// In en, this message translates to:
  /// **'Total number of items skipped and sent to the shadow budget.'**
  String get badgeVazgecisUstasiDesc;

  /// No description provided for @badgeGallery.
  ///
  /// In en, this message translates to:
  /// **'Badge Gallery'**
  String get badgeGallery;

  /// No description provided for @totalProgress.
  ///
  /// In en, this message translates to:
  /// **'Total Progress'**
  String get totalProgress;

  /// No description provided for @totalLevels.
  ///
  /// In en, this message translates to:
  /// **'Total Levels'**
  String get totalLevels;

  /// No description provided for @maxShort.
  ///
  /// In en, this message translates to:
  /// **'MAX'**
  String get maxShort;

  /// No description provided for @levelShort.
  ///
  /// In en, this message translates to:
  /// **'LVL'**
  String get levelShort;

  /// No description provided for @streakBadge.
  ///
  /// In en, this message translates to:
  /// **'🔥 Streak Badge'**
  String get streakBadge;

  /// No description provided for @cumulativeBadge.
  ///
  /// In en, this message translates to:
  /// **'📈 Cumulative Badge'**
  String get cumulativeBadge;

  /// No description provided for @maxLevelReached.
  ///
  /// In en, this message translates to:
  /// **'MAXIMUM LEVEL REACHED!'**
  String get maxLevelReached;

  /// No description provided for @subscriptionManagement.
  ///
  /// In en, this message translates to:
  /// **'Subscription Management'**
  String get subscriptionManagement;

  /// No description provided for @monthlyTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Monthly Total'**
  String get monthlyTotalLabel;

  /// No description provided for @expenseDistribution.
  ///
  /// In en, this message translates to:
  /// **'Expense Distribution'**
  String get expenseDistribution;

  /// No description provided for @detailsButton.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get detailsButton;

  /// No description provided for @mySubscriptions.
  ///
  /// In en, this message translates to:
  /// **'My Subscriptions'**
  String get mySubscriptions;

  /// No description provided for @onDate.
  ///
  /// In en, this message translates to:
  /// **'on the {date}'**
  String onDate(String date);

  /// No description provided for @addNewSubscription.
  ///
  /// In en, this message translates to:
  /// **'Add New Subscription'**
  String get addNewSubscription;

  /// No description provided for @noSubscriptionsAdded.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t added any subscriptions yet.'**
  String get noSubscriptionsAdded;

  /// No description provided for @nextLevelTarget.
  ///
  /// In en, this message translates to:
  /// **'Target for next level:\nYou need to do {count} more.'**
  String nextLevelTarget(int count);

  /// No description provided for @progressLabel.
  ///
  /// In en, this message translates to:
  /// **'{current} / {total} progress'**
  String progressLabel(int current, int total);

  /// No description provided for @monthlyReport.
  ///
  /// In en, this message translates to:
  /// **'Monthly Report'**
  String get monthlyReport;

  /// No description provided for @totalSpent.
  ///
  /// In en, this message translates to:
  /// **'TOTAL SPENT'**
  String get totalSpent;

  /// No description provided for @comparedToLastMonth.
  ///
  /// In en, this message translates to:
  /// **'%{percentage} {trend} than last month'**
  String comparedToLastMonth(String percentage, String trend);

  /// No description provided for @trendLess.
  ///
  /// In en, this message translates to:
  /// **'less'**
  String get trendLess;

  /// No description provided for @trendMore.
  ///
  /// In en, this message translates to:
  /// **'more'**
  String get trendMore;

  /// No description provided for @subscriptionDistribution.
  ///
  /// In en, this message translates to:
  /// **'Subscription Distribution'**
  String get subscriptionDistribution;

  /// No description provided for @upcomingPayments.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Payments'**
  String get upcomingPayments;

  /// No description provided for @noUpcomingPayments.
  ///
  /// In en, this message translates to:
  /// **'No upcoming payments.'**
  String get noUpcomingPayments;

  /// No description provided for @nextPaymentInDays.
  ///
  /// In en, this message translates to:
  /// **'NEXT UP • {days} DAYS LEFT'**
  String nextPaymentInDays(int days);

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @daysRemainingText.
  ///
  /// In en, this message translates to:
  /// **'{days} days left'**
  String daysRemainingText(int days);

  /// No description provided for @editSubscription.
  ///
  /// In en, this message translates to:
  /// **'Edit Subscription'**
  String get editSubscription;

  /// No description provided for @newSubscription.
  ///
  /// In en, this message translates to:
  /// **'New Subscription'**
  String get newSubscription;

  /// No description provided for @serviceIconLabel.
  ///
  /// In en, this message translates to:
  /// **'SERVICE ICON'**
  String get serviceIconLabel;

  /// No description provided for @serviceNameLabel.
  ///
  /// In en, this message translates to:
  /// **'SERVICE NAME'**
  String get serviceNameLabel;

  /// No description provided for @serviceNameHint.
  ///
  /// In en, this message translates to:
  /// **'E.g. Netflix, Spotify...'**
  String get serviceNameHint;

  /// No description provided for @monthlyFeeLabel.
  ///
  /// In en, this message translates to:
  /// **'MONTHLY FEE'**
  String get monthlyFeeLabel;

  /// No description provided for @paymentCycleLabel.
  ///
  /// In en, this message translates to:
  /// **'PAYMENT CYCLE'**
  String get paymentCycleLabel;

  /// No description provided for @wantNeedLabel.
  ///
  /// In en, this message translates to:
  /// **'WANT / NEED'**
  String get wantNeedLabel;

  /// No description provided for @needItem.
  ///
  /// In en, this message translates to:
  /// **'Need'**
  String get needItem;

  /// No description provided for @wantItem.
  ///
  /// In en, this message translates to:
  /// **'Want'**
  String get wantItem;

  /// No description provided for @necessityItem.
  ///
  /// In en, this message translates to:
  /// **'Necessity'**
  String get necessityItem;

  /// No description provided for @moodLabel.
  ///
  /// In en, this message translates to:
  /// **'MOOD'**
  String get moodLabel;

  /// No description provided for @happyItem.
  ///
  /// In en, this message translates to:
  /// **'Happy'**
  String get happyItem;

  /// No description provided for @neutralItem.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get neutralItem;

  /// No description provided for @regretItem.
  ///
  /// In en, this message translates to:
  /// **'Regret'**
  String get regretItem;

  /// No description provided for @nextPaymentDateLabel.
  ///
  /// In en, this message translates to:
  /// **'NEXT PAYMENT DATE'**
  String get nextPaymentDateLabel;

  /// No description provided for @dateHint.
  ///
  /// In en, this message translates to:
  /// **'dd.mm.yyyy'**
  String get dateHint;

  /// No description provided for @unnamed.
  ///
  /// In en, this message translates to:
  /// **'Unnamed'**
  String get unnamed;

  /// No description provided for @notSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get notSpecified;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'SAVE CHANGES'**
  String get saveChanges;

  /// No description provided for @saveSubscription.
  ///
  /// In en, this message translates to:
  /// **'SAVE SUBSCRIPTION'**
  String get saveSubscription;

  /// No description provided for @deleteSubscription.
  ///
  /// In en, this message translates to:
  /// **'DELETE SUBSCRIPTION'**
  String get deleteSubscription;

  /// No description provided for @editMyIcon.
  ///
  /// In en, this message translates to:
  /// **'Edit My Icon'**
  String get editMyIcon;

  /// No description provided for @customIcon.
  ///
  /// In en, this message translates to:
  /// **'Custom Icon'**
  String get customIcon;

  /// No description provided for @selectIconTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Icon'**
  String get selectIconTitle;

  /// No description provided for @uploadIcon.
  ///
  /// In en, this message translates to:
  /// **'UPLOAD ICON'**
  String get uploadIcon;

  /// No description provided for @popularCategory.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popularCategory;

  /// No description provided for @financeCategory.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get financeCategory;

  /// No description provided for @educationCategory.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get educationCategory;

  /// No description provided for @entertainmentCategory.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get entertainmentCategory;

  /// No description provided for @bankWord.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get bankWord;

  /// No description provided for @insuranceWord.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get insuranceWord;

  /// No description provided for @creditCardWord.
  ///
  /// In en, this message translates to:
  /// **'Credit Card'**
  String get creditCardWord;

  /// No description provided for @creditWord.
  ///
  /// In en, this message translates to:
  /// **'Loan/Credit'**
  String get creditWord;

  /// No description provided for @schoolWord.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get schoolWord;

  /// No description provided for @bookMagazineWord.
  ///
  /// In en, this message translates to:
  /// **'Book/Magazine'**
  String get bookMagazineWord;

  /// No description provided for @personalDevWord.
  ///
  /// In en, this message translates to:
  /// **'Personal Dev'**
  String get personalDevWord;

  /// No description provided for @courseWord.
  ///
  /// In en, this message translates to:
  /// **'Course'**
  String get courseWord;

  /// No description provided for @gameWord.
  ///
  /// In en, this message translates to:
  /// **'Game'**
  String get gameWord;

  /// No description provided for @cinemaSeriesWord.
  ///
  /// In en, this message translates to:
  /// **'Cinema/Series'**
  String get cinemaSeriesWord;

  /// No description provided for @musicWord.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get musicWord;

  /// No description provided for @eventActivityWord.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get eventActivityWord;

  /// No description provided for @totalUppercase.
  ///
  /// In en, this message translates to:
  /// **'TOTAL'**
  String get totalUppercase;

  /// No description provided for @spendingsTab.
  ///
  /// In en, this message translates to:
  /// **'Spendings'**
  String get spendingsTab;

  /// No description provided for @otherCategory.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get otherCategory;

  /// No description provided for @autoRenewal.
  ///
  /// In en, this message translates to:
  /// **'Auto Renewal'**
  String get autoRenewal;

  /// No description provided for @appPurposeHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Conscious Spending,\nFree Future.'**
  String get appPurposeHeroTitle;

  /// No description provided for @appPurposeHeroDesc.
  ///
  /// In en, this message translates to:
  /// **'Pretio transforms your expenses from mere numbers into their true impact on your life, helping you replace impulsive urges with conscious decisions that lead you to your dreams.'**
  String get appPurposeHeroDesc;

  /// No description provided for @feature1Title.
  ///
  /// In en, this message translates to:
  /// **'Fast and Practical Logging'**
  String get feature1Title;

  /// No description provided for @feature1Desc.
  ///
  /// In en, this message translates to:
  /// **'Log your expenses instantly and effortlessly. Instead of tedious forms, add your transactions in seconds, turning financial tracking into a pleasant daily habit.'**
  String get feature1Desc;

  /// No description provided for @feature2Title.
  ///
  /// In en, this message translates to:
  /// **'Emotional Finance Compass'**
  String get feature2Title;

  /// No description provided for @feature2Desc.
  ///
  /// In en, this message translates to:
  /// **'Discover the psychology behind every expense. Is it a real need or a sudden urge? Map your consumption habits and allocate your money only to things that bring you value.'**
  String get feature2Desc;

  /// No description provided for @feature3Title.
  ///
  /// In en, this message translates to:
  /// **'Focus on Your Dreams'**
  String get feature3Title;

  /// No description provided for @feature3Desc.
  ///
  /// In en, this message translates to:
  /// **'Plan not just for today, but for the future. Clearly see how close you are to your dream goal and direct your savings straight towards it.'**
  String get feature3Desc;

  /// No description provided for @feature4Title.
  ///
  /// In en, this message translates to:
  /// **'Detailed Analytics and Habit Tracking'**
  String get feature4Title;

  /// No description provided for @feature4Desc.
  ///
  /// In en, this message translates to:
  /// **'See transparently where your money goes. Discover your consumption habits by examining your spending trends and emotional distribution in detail with elegant charts.'**
  String get feature4Desc;

  /// No description provided for @feature5Title.
  ///
  /// In en, this message translates to:
  /// **'Fully Customizable'**
  String get feature5Title;

  /// No description provided for @feature5Desc.
  ///
  /// In en, this message translates to:
  /// **'Tailor your financial assistant to your lifestyle. Create your own categories, set your quick entry amounts, and celebrate your achievements with unique badges.'**
  String get feature5Desc;

  /// No description provided for @aboutHeroDesc.
  ///
  /// In en, this message translates to:
  /// **'Pretio isn\'t just an ordinary budget tracker; it\'s a personal life philosophy that gives you back control over your time, money, and emotions. Amidst the frenzy of consumerism, it is designed to remind you of your own willpower and illuminate the path to your dreams.'**
  String get aboutHeroDesc;

  /// No description provided for @aboutSection1Title.
  ///
  /// In en, this message translates to:
  /// **'Meaning of the Name'**
  String get aboutSection1Title;

  /// No description provided for @aboutSection1Desc.
  ///
  /// In en, this message translates to:
  /// **'Pretio derives its roots from the Latin word \"pretium\", meaning \"value\", \"worth\", and \"price\". Everything we buy in life comes not just at a financial cost, but at a true price paid with our time and emotions. Pretio exists to show you this true value.'**
  String get aboutSection1Desc;

  /// No description provided for @aboutSection2Title.
  ///
  /// In en, this message translates to:
  /// **'Its Simplicity'**
  String get aboutSection2Title;

  /// No description provided for @aboutSection2Desc.
  ///
  /// In en, this message translates to:
  /// **'It doesn\'t overwhelm you with complex financial tables, confusing menus, and exhausting charts. With its easy-on-the-eyes, minimalist design, it turns financial tracking from a source of stress into a peaceful daily routine.'**
  String get aboutSection2Desc;

  /// No description provided for @aboutSection3Title.
  ///
  /// In en, this message translates to:
  /// **'Its Awareness'**
  String get aboutSection3Title;

  /// No description provided for @aboutSection3Desc.
  ///
  /// In en, this message translates to:
  /// **'It shows you not just what you spend, but why you spend it. Illuminating your consumption psychology, it helps you understand whether the item you bought is a genuine need or a momentary whim.'**
  String get aboutSection3Desc;

  /// No description provided for @aboutSection4Title.
  ///
  /// In en, this message translates to:
  /// **'Its Practicality'**
  String get aboutSection4Title;

  /// No description provided for @aboutSection4Desc.
  ///
  /// In en, this message translates to:
  /// **'It perfectly keeps up with the pace of daily life. You can log expenses in seconds without filling out long and tedious forms, update your budget with a single touch, and summarize your financial status at a glance.'**
  String get aboutSection4Desc;

  /// No description provided for @aboutSection5Title.
  ///
  /// In en, this message translates to:
  /// **'Its Customizability'**
  String get aboutSection5Title;

  /// No description provided for @aboutSection5Desc.
  ///
  /// In en, this message translates to:
  /// **'Everyone\'s lifestyle and financial journey is unique to them. You can fully tailor Pretio to your own habits by creating your own spending categories, setting personalized goals, and adjusting your quick entry amounts.'**
  String get aboutSection5Desc;

  /// No description provided for @aboutFooterNote.
  ///
  /// In en, this message translates to:
  /// **'This app was brought to life by an independent group of developers to help you protect your own willpower against the frenzy of consumerism.'**
  String get aboutFooterNote;

  /// No description provided for @developersTitle.
  ///
  /// In en, this message translates to:
  /// **'Our Developers'**
  String get developersTitle;

  /// No description provided for @averageSoFar.
  ///
  /// In en, this message translates to:
  /// **'Average so far'**
  String get averageSoFar;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @currentNetBalance.
  ///
  /// In en, this message translates to:
  /// **'Current Net Balance'**
  String get currentNetBalance;

  /// No description provided for @makeTransaction.
  ///
  /// In en, this message translates to:
  /// **'Make Transaction'**
  String get makeTransaction;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @insightProjectionGood.
  ///
  /// In en, this message translates to:
  /// **'At this rate, you will save {percent}% more than your target by month end.'**
  String insightProjectionGood(String percent);

  /// No description provided for @insightProjectionBad.
  ///
  /// In en, this message translates to:
  /// **'At this rate, you will save {percent}% less than your target by month end.'**
  String insightProjectionBad(String percent);

  /// No description provided for @insightCategoryAlert.
  ///
  /// In en, this message translates to:
  /// **'You spent the most in the {category} category this month.'**
  String insightCategoryAlert(String category);

  /// No description provided for @insightStreak.
  ///
  /// In en, this message translates to:
  /// **'Great! You haven\'t spent anything for {days} days.'**
  String insightStreak(int days);
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
      <String>['de', 'en', 'es', 'fr', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

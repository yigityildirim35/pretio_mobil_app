// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Zeitkostenrechner';

  @override
  String get balance => 'Kontostand';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get calendar => 'Kalender';

  @override
  String get reports => 'Berichte';

  @override
  String get settings => 'Einstellungen';

  @override
  String get theme => 'Design';

  @override
  String get language => 'Sprache';

  @override
  String get selectLanguage => 'Sprache auswählen';

  @override
  String get today => 'Heute';

  @override
  String get yesterday => 'Gestern';

  @override
  String get analytics => 'Analytik';

  @override
  String get coach => 'Trainer';

  @override
  String get shadow => 'Schatten';

  @override
  String get time => 'Zeit';

  @override
  String get profile => 'Profil';

  @override
  String get setDailyGoal => 'Tagesziel festlegen';

  @override
  String get addQuickAmount => 'Schnellbetrag hinzufügen';

  @override
  String get needs => 'Bedürfnisse';

  @override
  String get wants => 'Wünsche';

  @override
  String get total => 'Gesamt';

  @override
  String get currentStreak => 'Aktuelle Strähne';

  @override
  String get longestStreak => 'Längste Strähne';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';

  @override
  String get add => 'Hinzufügen';

  @override
  String get delete => 'Löschen';

  @override
  String editAmount(double amount) {
    final intl.NumberFormat amountNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String amountString = amountNumberFormat.format(amount);

    return 'Betrag bearbeiten $amountString';
  }

  @override
  String get deleteAmountConfirmation =>
      'Möchten Sie diesen Schnellbetrag löschen?';

  @override
  String get manage => 'Verwalten';

  @override
  String get done => 'Fertig';

  @override
  String get addTransaction => 'Transaktion hinzufügen';

  @override
  String get whatDidYouBuy => 'Was hast du gekauft?';

  @override
  String get howDoYouFeel => 'Wie fühlst du dich dabei?';

  @override
  String get isThisNeedOrWant =>
      'Ist das ein Bedürfnis, Wunsch oder eine Notwendigkeit?';

  @override
  String get saveTransaction => 'Transaktion speichern';

  @override
  String get recentActivity => 'Letzte Aktivität';

  @override
  String get viewAll => 'Alle anzeigen';

  @override
  String get noRecentActivity => 'Keine aktuellen Aktivitäten';

  @override
  String get newCategory => 'Neue Kategorie';

  @override
  String get categoryName => 'Kategoriename';

  @override
  String get selectIcon => 'Symbol auswählen';

  @override
  String get selectColor => 'Farbe auswählen';

  @override
  String get create => 'Erstellen';

  @override
  String get shadowBudget => 'Schattenbudget';

  @override
  String get item => 'Artikel';

  @override
  String get price => 'Preis';

  @override
  String get howDidItFeel => 'Wie hat es sich angefühlt, es nicht zu kaufen?';

  @override
  String get proud => 'Stolz';

  @override
  String get relieved => 'Erleichtert';

  @override
  String get sad => 'Traurig';

  @override
  String get iDidntBuyIt => 'Ich habe es nicht gekauft!';

  @override
  String totalSaved(double amount) {
    final intl.NumberFormat amountNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String amountString = amountNumberFormat.format(amount);

    return 'Insgesamt gespart: $amountString';
  }

  @override
  String get examples => 'BEISPIELE';

  @override
  String memberSince(int year) {
    return 'Mitglied seit $year';
  }

  @override
  String get financialHealth => 'Finanzielle Gesundheit';

  @override
  String get excellent => 'Ausgezeichnet';

  @override
  String get personalInformation => 'Persönliche Daten';

  @override
  String get annualSalary => 'Jahresgehalt';

  @override
  String get weeklyHours => 'Wochenstunden';

  @override
  String get appPreferences => 'App-Einstellungen';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get darkMode => 'Dunkelmodus';

  @override
  String get security => 'Sicherheit';

  @override
  String get faceIdLogin => 'FaceID Login';

  @override
  String get changePassword => 'Passwort ändern';

  @override
  String get timeValue => 'Zeitwert';

  @override
  String get yourProfileShared => 'DEIN PROFIL (Geteilt)';

  @override
  String get monthlySalary => 'Monatsgehalt';

  @override
  String get recalculateRate => 'Tarif neu berechnen';

  @override
  String get yourTimeIsWorth => 'Deine Zeit ist es wert';

  @override
  String get tlPhr => '/std';

  @override
  String get howMuchLife => 'WIE VIEL LEBEN KOSTET ES?';

  @override
  String get trends => 'Trends';

  @override
  String get noTransactionsYet => 'Noch keine Transaktionen.';

  @override
  String get good => 'Gut';

  @override
  String get okay => 'Okay';

  @override
  String get regret => 'Bedauern';

  @override
  String get overBudget => 'Budget überstritten';

  @override
  String get onTrack => 'Auf Kurs';

  @override
  String get monthlyAvg => 'MONATL. DURCHSCHN.';

  @override
  String get day => 'Tag';

  @override
  String get perDay => '/ Tag';

  @override
  String days(int count) {
    return '$count Tage';
  }

  @override
  String get financialCoach => 'Finanzcoach';

  @override
  String get moodVsMoney => 'Stimmungs-Geld';

  @override
  String get needVsWant => 'Bedürfnis-Wunsch';

  @override
  String deleteCategoryTitle(String category) {
    return '\"$category\" löschen?';
  }

  @override
  String get deleteCategoryContent =>
      'Dadurch wird die Kategorie nur aus der Liste entfernt. Bei bestehenden Transaktionen bleibt dieser Kategoriename erhalten.';

  @override
  String get remaining => 'Verbleibend';

  @override
  String goal(double amount) {
    final intl.NumberFormat amountNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String amountString = amountNumberFormat.format(amount);

    return 'ZIEL: $amountString';
  }

  @override
  String get transactionHistory => 'Transaktionsverlauf';

  @override
  String get currency => 'Währung';

  @override
  String get editTransactionTitle => 'Transaktion bearbeiten';

  @override
  String get titleLabel => 'Titel';

  @override
  String get amountLabel => 'Betrag';

  @override
  String get favorite => 'Favorit';

  @override
  String get need => 'Bedürfnis';

  @override
  String get want => 'Wunsch';

  @override
  String get necessity => 'Notwendigkeit';

  @override
  String get spendingBalance => 'Ausgabensaldo';

  @override
  String get emotionalImpact => 'Emotionale Auswirkungen';

  @override
  String get budgetProgress => 'Fortschritt Budget';

  @override
  String get weeklyLimit => 'Wöchentliches Limit';

  @override
  String get monthlyLimit => 'Monatliches Limit';

  @override
  String get underDailyGoal => 'unter Tagesziel';

  @override
  String get overDailyGoal => 'über Tagesziel';

  @override
  String get fancyLatte => 'Schicker Latte';

  @override
  String get runningShoes => 'Laufschuhe';

  @override
  String get flagshipPhone => 'Flaggschiff-Handy';

  @override
  String get sedanCar => 'Limousine';

  @override
  String get catFood => 'Essen';

  @override
  String get catTransport => 'Transport';

  @override
  String get catShopping => 'Einkaufen';

  @override
  String get catFun => 'Spaß';

  @override
  String get catBills => 'Rechnungen';

  @override
  String get catOther => 'Andere';

  @override
  String get phone => 'Telefon';

  @override
  String get undoTransactionQuestion =>
      'Möchten Sie diese Transaktion rückgängig machen?';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get addNote => 'Notiz hinzufügen';

  @override
  String get enterNote => 'Hier Notiz eingeben...';

  @override
  String get budgetPlanner => 'Budgetplaner';

  @override
  String get pleaseEnterItemAndPrice => 'Bitte Artikel und Preis eingeben';

  @override
  String get victorySaved => 'Sieg gespeichert! 🎉';

  @override
  String get editGoal => 'Ziel bearbeiten';

  @override
  String get goalName => 'Zielname';

  @override
  String get goalAmount => 'Zielbetrag';

  @override
  String get rateUpdated => 'Tarif aktualisiert! 🚀';

  @override
  String get coffeeShoesEta => 'Kaffee, Schuhe usw.';

  @override
  String get howMuchWasIt => 'Wie viel war es?';

  @override
  String get happy => 'Glücklich';

  @override
  String get neutral => 'Vorurteilslos';

  @override
  String get reclaimed => 'ZURÜCKGEFORDERT';

  @override
  String get workHours => 'Arbeitsstunden';

  @override
  String get mountainOfSavings => 'Berg der Ersparnisse';

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
    return '$percent% bis zum Gipfel';
  }

  @override
  String get recentVictories => 'Letzte Siege';

  @override
  String get noVictoriesYet => 'Noch keine Siege verbucht.';

  @override
  String savedHours(String hours) {
    return '$hours Stunden zurückgefordert';
  }

  @override
  String get edit => 'Bearbeiten';

  @override
  String get editVictory => 'Sieg bearbeiten';

  @override
  String get minShort => 'm';

  @override
  String get hrShort => 'h';

  @override
  String get workDay => 'Arbeitstag';

  @override
  String get monthShort => 'Monat';

  @override
  String get workShort => 'Arbeit';

  @override
  String get categories => 'Kategorien';

  @override
  String get weekly => 'Wöchentlich';

  @override
  String get monthly => 'Monatlich';

  @override
  String get yearly => 'Jährlich';

  @override
  String get goals => 'Ziele';

  @override
  String get noSpendToast => 'Ausgaben heute erfasst!';

  @override
  String get noSpendTitle => 'Keine Ausgaben';

  @override
  String get noSpendNote => 'Heute wurden keine Ausgaben getätigt';

  @override
  String get deletedData => 'Gelöschte Daten';

  @override
  String get settingsAndPreferences => 'EINSTELLUNGEN UND PRÄFERENZEN';

  @override
  String get account => 'Konto';

  @override
  String get profileNameLabel => 'PROFILNAME';

  @override
  String get avatarLabel => 'AVATAR';

  @override
  String get personalizeCharacter => 'Passe deinen Charakter an';

  @override
  String get changeAvatar => 'AVATAR ÄNDERN';

  @override
  String get balanceAndFinance => 'Kontostand und Finanzen';

  @override
  String get balanceInfoLabel => 'KONTO-INFO';

  @override
  String currentBalance(String amount) {
    return 'AKTUELL: $amount';
  }

  @override
  String get currencyLabel => 'WÄHRUNG';

  @override
  String get appearance => 'Erscheinungsbild';

  @override
  String get languageSelectionLabel => 'SPRACHAUSWAHL';

  @override
  String get themesLabel => 'DESIGNS';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeForest => 'Waldgrün';

  @override
  String get themeCottonCandy => 'Zuckerwatte';

  @override
  String get themeSunset => 'Sonnenuntergang';

  @override
  String get themeProfileDark => 'Nachtblau';

  @override
  String get themeAmoled => 'Dunkel';

  @override
  String get preferences => 'Präferenzen';

  @override
  String get hideSpentMoney => 'AUSGEGEBENES GELD VERBERGEN';

  @override
  String get privacyMode => 'Privatmodus';

  @override
  String get needWantModule => 'MODUL BEDÜRFNIS - WUNSCH';

  @override
  String get showWhenAddingNew => 'Beim Hinzufügen anzeigen';

  @override
  String get emotionModule => 'MODUL EMOTION';

  @override
  String get view3D => '3D-ANSICHT';

  @override
  String get addEmbossEffect => '3D-Effekt hinzufügen';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get deleteAll => 'ALLES LÖSCHEN';

  @override
  String get deletePermanently => 'Alle Daten dauerhaft löschen';

  @override
  String get buttonDelete => 'LÖSCHEN';

  @override
  String get about => 'Über';

  @override
  String get appPurpose => 'APP-ZWECK';

  @override
  String get whyAreWeHere => 'Warum sind wir hier?';

  @override
  String get aboutApp => 'ÜBER DIE APP';

  @override
  String get versionAndDetails => 'Version und Details';

  @override
  String get creators => 'ENTWICKLER';

  @override
  String get whoDevelopedIt => 'Wer hat es entwickelt?';

  @override
  String get selectAvatar => 'Avatar wählen';

  @override
  String get editPhoto => 'Foto bearbeiten';

  @override
  String get statistics => 'Statistiken';

  @override
  String get highestStreak => 'BESTE SERIE';

  @override
  String get totalSpending => 'GESAMTAUSGABEN';

  @override
  String get currentStreakLabel => 'AKTUELLE SERIE';

  @override
  String get financialIq => 'Finanz-IQ';

  @override
  String percentNeed(int percent) {
    return '$percent% Bed.';
  }

  @override
  String percentWant(int percent) {
    return '$percent% Wunsch';
  }

  @override
  String percentObligation(int percent) {
    return '$percent% Oblig.';
  }

  @override
  String get subscriptions => 'Abonnements';

  @override
  String get seeAll => 'ALLE SEHEN';

  @override
  String get noSubscriptionsYet => 'Du hast noch keine Abonnements.';

  @override
  String get badgesAndAchievements => 'Abzeichen & Erfolge';

  @override
  String get accountOperations => 'Konto-Optionen';

  @override
  String get addIncome => 'Einkommen Hinzufügen';

  @override
  String get unexpectedMoney => 'Unerwartetes Geld?';

  @override
  String get enterAmount => 'Betrag eingeben';

  @override
  String get buttonAdd => 'Hinzufügen';

  @override
  String get editTotalBalance => 'Gesamtsaldo Bearbeiten';

  @override
  String get resetInitialBalance => 'Anfangssaldo zurücksetzen';

  @override
  String get updateBalance => 'Saldo Aktualisieren';

  @override
  String get buttonUpdate => 'Aktualisieren';

  @override
  String get areYouSure => 'Bist du dir sicher?';

  @override
  String get deleteWarning =>
      'Alle Kosten und Einstellungen werden dauerhaft gelöscht.';

  @override
  String get yesContinue => 'Ja, Weiter';

  @override
  String get finalConfirmation => 'Letzte Bestätigung';

  @override
  String get pressToClearData => 'Drücken, um Daten zu löschen.';

  @override
  String secondsRemaining(int seconds) {
    return '$seconds sekunden...';
  }

  @override
  String get deleteNow => 'JETZT LÖSCHEN';

  @override
  String get waiting => 'Warten...';

  @override
  String get insightsTitle => 'Vorausschauende Einblicke';

  @override
  String get goalUnreachable =>
      'Ihre aktuelle Ausgabenrate verhindert, dass Sie sparen. Ziel ist unerreichbar!';

  @override
  String goalReachableDesc(int days) {
    return 'Bei Ihrer aktuellen Ausgabenrate erreichen Sie Ihr Ziel in etwa $days Tagen.';
  }

  @override
  String budgetEmptyWarning(int days) {
    return 'Warnung: Bei dieser Ausgabenrate ist Ihr Budget in $days Tagen aufgebraucht!';
  }

  @override
  String get budgetSafe =>
      'Ihr Budget ist bei der aktuellen Ausgabenrate sicher.';

  @override
  String get dailyAverageSavings => 'Durchschnittliche Tägliche Ersparnisse';

  @override
  String get accountActions => 'Kontoaktionen';

  @override
  String get addIncomeDesc => 'Haben Sie unerwartetes Geld erhalten?';

  @override
  String get noNoteAttached => 'Keine Notiz';

  @override
  String get categoryDistribution => 'Kategorienverteilung';

  @override
  String get balanceSummary => 'Kontostandszusammenfassung';

  @override
  String get remainingBalanceText => 'Verbleibender Saldo';

  @override
  String categoryBudgetShare(String percentage) {
    return 'Budgetanteil: $percentage%';
  }

  @override
  String get spentAmount => 'Ausgegeben';

  @override
  String lastMonthPlus(String diff) {
    return 'Letzter Monat: +$diff%';
  }

  @override
  String lastMonthMinus(String diff) {
    return 'Letzter Monat: $diff%';
  }

  @override
  String get sameAsLastMonth => 'Gleich wie im letzten Monat';

  @override
  String get newData => 'Neue Daten';

  @override
  String get obligationWarning =>
      'Dies ist eine obligatorische Ausgabe. Sie wirkt sich nicht auf Ihr Tageslimit aus, sondern wird nur von Ihrem Hauptguthaben abgezogen.';

  @override
  String get tapForDetails => 'Tippen für Details';

  @override
  String transactionCount(String count) {
    return '$count Transaktionen';
  }

  @override
  String get noRecordsToday => 'Keine Einträge für diesen Tag.';

  @override
  String get goalCurrentGoal => 'Aktuelles Ziel';

  @override
  String get goalTotalSavings => 'Gesamtersparnisse (Im Tresor)';

  @override
  String get goalThisMonthTask => 'Aufgabe dieses Monats (Geschützt)';

  @override
  String get goalRemainingNet => 'Verbleibendes Ziel';

  @override
  String get goalIfProtected => 'Wenn in diesem Monat geschützt';

  @override
  String get goalUpdateBtn => 'Aktualisieren';

  @override
  String get goalAddBtn => 'Hinzufügen';

  @override
  String get goalBalanceAction => 'Kontobewegung';

  @override
  String get goalWithdrawMoney => 'Abheben';

  @override
  String get goalEnterAmountHint => 'Betrag eingeben (z. B. 500)';

  @override
  String get goalWithdrawBtn => 'Abheben';

  @override
  String get goalSpendingPower => 'Kaufkraft';

  @override
  String get goalDailyLimit => 'Tageslimit';

  @override
  String get goalOnTarget => 'Im Tagesziel';

  @override
  String get goalLimitExceeded => 'Limit überschritten';

  @override
  String get goalEditPlan => 'Finanzplan bearbeiten';

  @override
  String get goalDistributable => 'Verteilbar';

  @override
  String get goalMonthlyTarget => 'Monatsziel';

  @override
  String get goalDaily => 'Täglich';

  @override
  String get goalResetTitle => 'Ziel zurücksetzen?';

  @override
  String get goalResetDesc =>
      'Möchten Sie Ihr aktuelles Ziel und alle Ersparnisse wirklich zurücksetzen? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get goalCancelBtn => 'Abbrechen';

  @override
  String get goalResetSuccessMsg => 'Ziel und Ersparnisse zurückgesetzt.';

  @override
  String get goalResetBtn => 'Zurücksetzen';

  @override
  String get goalUpdateGoalTitle => 'Ziel aktualisieren';

  @override
  String get goalNameInputLabel => 'Artikelname';

  @override
  String get goalTargetPrice => 'Zielpreis';

  @override
  String get goalSaveBtn => 'Speichern';

  @override
  String get goalUpdateGoalsTitle => 'Ziele aktualisieren';

  @override
  String get goalMonthlySavingsTarget => 'Monatliches Sparziel';

  @override
  String get shadowItemHint => 'z.B. Kaffee, Kopfhörer...';

  @override
  String get badgeKutsalSeriTitle => 'Die Heilige Serie';

  @override
  String get badgeKutsalSeriDesc =>
      'Anzahl aufeinanderfolgender Tage ohne Ausgaben.';

  @override
  String get badgeCuzdanBekcisiTitle => 'Wallet-Wächter';

  @override
  String get badgeCuzdanBekcisiDesc =>
      'Gesamtzahl der Tage ohne jegliche Ausgaben.';

  @override
  String get badgeDuyguDedektifiTitle => 'Emotionsdetektiv';

  @override
  String get badgeDuyguDedektifiDesc =>
      'Gesamtzahl der protokollierten Transaktionen mit einer Emotion.';

  @override
  String get badgeDuzenUzmaniTitle => 'Gleichgewichtsexperte';

  @override
  String get badgeDuzenUzmaniDesc =>
      'Gesamtzahl der Transaktionen, die als Bedürfnis, Wunsch oder Verpflichtung markiert sind.';

  @override
  String get badgeVeriKurduTitle => 'Daten-Nerd';

  @override
  String get badgeVeriKurduDesc =>
      'Gesamtzahl der im System erfassten Ausgabentransaktionen.';

  @override
  String get badgeVazgecisUstasiTitle => 'Meister des Verzichts';

  @override
  String get badgeVazgecisUstasiDesc =>
      'Gesamtzahl der Artikel, die übersprungen und ins Schattenbudget übertragen wurden.';

  @override
  String get badgeGallery => 'Abzeichen-Galerie';

  @override
  String get totalProgress => 'Gesamtfortschritt';

  @override
  String get totalLevels => 'Gesamtstufen';

  @override
  String get maxShort => 'MAX';

  @override
  String get levelShort => 'LVL';

  @override
  String get streakBadge => '🔥 Serien-Abzeichen';

  @override
  String get cumulativeBadge => '📈 Kumulatives Abzeichen';

  @override
  String get maxLevelReached => 'MAXIMALSTUFE ERREICHT!';

  @override
  String get subscriptionManagement => 'Abonnementverwaltung';

  @override
  String get monthlyTotalLabel => 'Monatssumme';

  @override
  String get expenseDistribution => 'Ausgabenverteilung';

  @override
  String get detailsButton => 'Details';

  @override
  String get mySubscriptions => 'Meine Abonnements';

  @override
  String onDate(String date) {
    return 'am $date';
  }

  @override
  String get addNewSubscription => 'Neues Abonnement Hinzufügen';

  @override
  String get noSubscriptionsAdded =>
      'Sie haben noch keine Abonnements hinzugefügt.';

  @override
  String nextLevelTarget(int count) {
    return 'Ziel für nächste Stufe:\nSie müssen noch $count durchführen.';
  }

  @override
  String progressLabel(int current, int total) {
    return '$current / $total Fortschritt';
  }

  @override
  String get monthlyReport => 'Monatsbericht';

  @override
  String get totalSpent => 'GESAMTAUSGABEN';

  @override
  String comparedToLastMonth(String percentage, String trend) {
    return '%$percentage $trend als im letzten Monat';
  }

  @override
  String get trendLess => 'weniger';

  @override
  String get trendMore => 'mehr';

  @override
  String get subscriptionDistribution => 'Verteilung der Abonnements';

  @override
  String get upcomingPayments => 'Anstehende Zahlungen';

  @override
  String get noUpcomingPayments => 'Keine anstehenden Zahlungen.';

  @override
  String nextPaymentInDays(int days) {
    return 'NÄCHSTES • NOCH $days TAGE';
  }

  @override
  String get unknown => 'Unbekannt';

  @override
  String daysRemainingText(int days) {
    return 'Noch $days Tage';
  }

  @override
  String get editSubscription => 'Abonnement Bearbeiten';

  @override
  String get newSubscription => 'Neues Abonnement';

  @override
  String get serviceIconLabel => 'DIENST-SYMBOL';

  @override
  String get serviceNameLabel => 'DIENST-NAME';

  @override
  String get serviceNameHint => 'Z.B. Netflix, Spotify...';

  @override
  String get monthlyFeeLabel => 'MONATLICHE GEBÜHR';

  @override
  String get paymentCycleLabel => 'ZAHLUNGSZYKLUS';

  @override
  String get wantNeedLabel => 'WUNSCH / BEDARF';

  @override
  String get needItem => 'Bedarf';

  @override
  String get wantItem => 'Wunsch';

  @override
  String get necessityItem => 'Notwendigkeit';

  @override
  String get moodLabel => 'STIMMUNG';

  @override
  String get happyItem => 'Glücklich';

  @override
  String get neutralItem => 'Neutral';

  @override
  String get regretItem => 'Bedauern';

  @override
  String get nextPaymentDateLabel => 'NÄCHSTES ZAHLUNGSDATUM';

  @override
  String get dateHint => 'tt.mm.jjjj';

  @override
  String get unnamed => 'Unbenannt';

  @override
  String get notSpecified => 'Nicht angegeben';

  @override
  String get saveChanges => 'ÄNDERUNGEN SPEICHERN';

  @override
  String get saveSubscription => 'ABONNEMENT SPEICHERN';

  @override
  String get deleteSubscription => 'ABONNEMENT LÖSCHEN';

  @override
  String get editMyIcon => 'Mein Symbol bearbeiten';

  @override
  String get customIcon => 'Benutzerdefiniertes Symbol';

  @override
  String get selectIconTitle => 'Symbol Auswählen';

  @override
  String get uploadIcon => 'SYMBOL HOCHLADEN';

  @override
  String get popularCategory => 'Beliebt';

  @override
  String get financeCategory => 'Finanzen';

  @override
  String get educationCategory => 'Bildung';

  @override
  String get entertainmentCategory => 'Unterhaltung';

  @override
  String get bankWord => 'Bank';

  @override
  String get insuranceWord => 'Versicherung';

  @override
  String get creditCardWord => 'Kreditkarte';

  @override
  String get creditWord => 'Kredit';

  @override
  String get schoolWord => 'Schule';

  @override
  String get bookMagazineWord => 'Buch/Magazin';

  @override
  String get personalDevWord => 'Persönliche Entw.';

  @override
  String get courseWord => 'Kurs';

  @override
  String get gameWord => 'Spiel';

  @override
  String get cinemaSeriesWord => 'Kino/Serie';

  @override
  String get musicWord => 'Musik';

  @override
  String get eventActivityWord => 'Ereignis';

  @override
  String get totalUppercase => 'GESAMT';

  @override
  String get spendingsTab => 'Ausgaben';

  @override
  String get otherCategory => 'Andere';

  @override
  String get autoRenewal => 'Automatische Verlängerung';

  @override
  String get appPurposeHeroTitle => 'Bewusstes Ausgeben,\nFreie Zukunft.';

  @override
  String get appPurposeHeroDesc =>
      'Pretio verwandelt Ihre Ausgaben von bloßen Zahlen in ihre tatsächliche Wirkung auf Ihr Leben und hilft Ihnen, impulsive Ausgaben durch bewusste Entscheidungen zu ersetzen, die Sie Ihren Träumen näherbringen.';

  @override
  String get feature1Title => 'Schnelles und Praktisches Erfassen';

  @override
  String get feature1Desc =>
      'Erfassen Sie Ihre Ausgaben sofort und mühelos. Fügen Sie Ihre Transaktionen in Sekundenschnelle hinzu und machen Sie so die Finanzplanung zu einer angenehmen täglichen Gewohnheit.';

  @override
  String get feature2Title => 'Emotionaler Finanzkompass';

  @override
  String get feature2Desc =>
      'Entdecken Sie die Psychologie hinter jeder Ausgabe. Ist es ein echtes Bedürfnis oder ein plötzlicher Drang? Kartieren Sie Ihr Konsumverhalten und geben Sie Ihr Geld nur für Dinge aus, die Ihnen Mehrwert bringen.';

  @override
  String get feature3Title => 'Konzentrieren Sie sich auf Ihre Träume';

  @override
  String get feature3Desc =>
      'Planen Sie nicht nur für heute, sondern für die Zukunft. Sehen Sie klar, wie nah Sie Ihrem Traumziel sind, und lenken Sie Ihre Ersparnisse direkt dorthin.';

  @override
  String get feature4Title => 'Detaillierte Analyse und Gewohnheitstracking';

  @override
  String get feature4Desc =>
      'Sehen Sie transparent, wohin Ihr Geld fließt. Entdecken Sie Ihr Konsumverhalten, indem Sie Ihre Ausgabentrends und die emotionale Verteilung mit eleganten Diagrammen genauer analysieren.';

  @override
  String get feature5Title => 'Vollständig Anpassbar';

  @override
  String get feature5Desc =>
      'Passen Sie Ihren Finanzassistenten an Ihren Lebensstil an. Erstellen Sie eigene Kategorien, legen Sie Schnelleingabebeträge fest und feiern Sie Ihre Erfolge mit einzigartigen Abzeichen.';

  @override
  String get aboutHeroDesc =>
      'Pretio ist nicht nur ein gewöhnlicher Budget-Tracker; es ist eine persönliche Lebensphilosophie, die Ihnen die Kontrolle über Ihre Zeit, Ihr Geld und Ihre Emotionen zurückgibt. Mitten im Konsumrausch soll es Sie an Ihre eigene Willenskraft erinnern und den Weg zu Ihren Träumen beleuchten.';

  @override
  String get aboutSection1Title => 'Bedeutung des Namens';

  @override
  String get aboutSection1Desc =>
      'Pretio leitet sich vom lateinischen Wort \"pretium\" ab, was \"Wert\", \"Preis\" und \"Bedeutung\" heißt. Alles, was wir im Leben kaufen, hat nicht nur einen finanziellen Preis, sondern einen wahren Preis, den wir mit unserer Zeit und unseren Emotionen zahlen. Pretio existiert, um Ihnen diesen wahren Wert zu zeigen.';

  @override
  String get aboutSection2Title => 'Seine Einfachheit';

  @override
  String get aboutSection2Desc =>
      'Es überfordert Sie nicht mit komplexen Finanztabellen, verwirrenden Menüs und anstrengenden Diagrammen. Mit seinem augenschonenden, minimalistischen Design verwandelt es das Finanztracking von einer Stressquelle in eine friedliche tägliche Routine.';

  @override
  String get aboutSection3Title => 'Seine Bewusstheit';

  @override
  String get aboutSection3Desc =>
      'Es zeigt Ihnen nicht nur, was Sie ausgeben, sondern warum Sie es ausgeben. Es beleuchtet Ihre Konsumpsychologie und hilft Ihnen zu verstehen, ob der gekaufte Artikel ein echtes Bedürfnis oder eine momentane Laune ist.';

  @override
  String get aboutSection4Title => 'Seine Praktikabilität';

  @override
  String get aboutSection4Desc =>
      'Es hält perfekt mit dem Tempo des täglichen Lebens Schritt. Sie können Ausgaben in Sekundenschnelle erfassen, ohne lange Formulare auszufüllen, Ihr Budget mit einer einzigen Berührung aktualisieren und Ihren Finanzstatus auf einen Blick zusammenfassen.';

  @override
  String get aboutSection5Title => 'Seine Anpassbarkeit';

  @override
  String get aboutSection5Desc =>
      'Jeder Lebensstil und jede finanzielle Reise ist einzigartig. Sie können Pretio vollständig an Ihre eigenen Gewohnheiten anpassen, indem Sie Ihre eigenen Ausgabenkategorien erstellen, persönliche Ziele festlegen und Ihre Schnelleingabebeträge anpassen.';

  @override
  String get aboutFooterNote =>
      'Diese App wurde von einer unabhängigen Gruppe von Entwicklern ins Leben gerufen, um Ihnen zu helfen, Ihre eigene Willenskraft gegen den Konsumwahn zu schützen.';

  @override
  String get developersTitle => 'Unsere Entwickler';

  @override
  String get averageSoFar => 'Bisheriger Durchschnitt';

  @override
  String get all => 'Alle';

  @override
  String get favorites => 'Favoriten';

  @override
  String get currentNetBalance => 'Aktueller Nettosaldo';

  @override
  String get makeTransaction => 'Transaktion durchführen';

  @override
  String get expense => 'Expense';

  @override
  String get income => 'Income';

  @override
  String insightProjectionGood(String percent) {
    return 'Bei diesem Tempo werden Sie am Monatsende $percent% mehr als Ihr Ziel sparen.';
  }

  @override
  String insightProjectionBad(String percent) {
    return 'Bei diesem Tempo werden Sie am Monatsende $percent% weniger als Ihr Ziel sparen.';
  }

  @override
  String insightCategoryAlert(String category) {
    return 'Sie haben in diesem Monat am meisten in $category ausgegeben.';
  }

  @override
  String insightStreak(int days) {
    return 'Großartig! Sie haben $days Tage lang nichts ausgegeben.';
  }
}

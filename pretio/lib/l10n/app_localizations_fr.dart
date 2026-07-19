// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Calculateur de Coût en Temps';

  @override
  String get balance => 'Balance';

  @override
  String get dashboard => 'Tableau de bord';

  @override
  String get calendar => 'Calendrier';

  @override
  String get reports => 'Rapports';

  @override
  String get settings => 'Paramètres';

  @override
  String get theme => 'Thème';

  @override
  String get language => 'Langue';

  @override
  String get selectLanguage => 'Choisir la Langue';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get yesterday => 'Hier';

  @override
  String get analytics => 'Analyses';

  @override
  String get coach => 'Coach';

  @override
  String get shadow => 'Ombre';

  @override
  String get time => 'Temps';

  @override
  String get profile => 'Profil';

  @override
  String get setDailyGoal => 'Définir l\'Objectif Quotidien';

  @override
  String get addQuickAmount => 'Ajouter un Montant Rapide';

  @override
  String get needs => 'Besoins';

  @override
  String get wants => 'Envies';

  @override
  String get total => 'Total';

  @override
  String get currentStreak => 'Série Actuelle';

  @override
  String get longestStreak => 'Plus Longue Série';

  @override
  String get cancel => 'Annuler';

  @override
  String get save => 'Enregistrer';

  @override
  String get add => 'Ajouter';

  @override
  String get delete => 'Supprimer';

  @override
  String editAmount(double amount) {
    final intl.NumberFormat amountNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String amountString = amountNumberFormat.format(amount);

    return 'Modifier le Montant $amountString';
  }

  @override
  String get deleteAmountConfirmation =>
      'Voulez-vous supprimer ce montant rapide ?';

  @override
  String get manage => 'Gérer';

  @override
  String get done => 'Terminé';

  @override
  String get addTransaction => 'Ajouter une transaction';

  @override
  String get whatDidYouBuy => 'Qu\'avez-vous acheté ?';

  @override
  String get howDoYouFeel => 'Que ressentez-vous à ce sujet ?';

  @override
  String get isThisNeedOrWant =>
      'Est-ce un Besoin, une Envie ou une Obligation ?';

  @override
  String get saveTransaction => 'Enregistrer la Transaction';

  @override
  String get recentActivity => 'Activité Récente';

  @override
  String get viewAll => 'Voir Tout';

  @override
  String get noRecentActivity => 'Aucune activité récente';

  @override
  String get newCategory => 'Nouvelle Catégorie';

  @override
  String get categoryName => 'Nom de la Catégorie';

  @override
  String get selectIcon => 'Sélectionner une Icône';

  @override
  String get selectColor => 'Sélectionner une Couleur';

  @override
  String get create => 'Créer';

  @override
  String get shadowBudget => 'Budget Fantôme';

  @override
  String get item => 'Article';

  @override
  String get price => 'Prix';

  @override
  String get howDidItFeel => 'Qu\'avez-vous ressenti en ne l\'achetant pas ?';

  @override
  String get proud => 'Fier';

  @override
  String get relieved => 'Soulagé';

  @override
  String get sad => 'Triste';

  @override
  String get iDidntBuyIt => 'Je Ne L\'ai Pas Acheté !';

  @override
  String totalSaved(double amount) {
    final intl.NumberFormat amountNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String amountString = amountNumberFormat.format(amount);

    return 'Total Économisé : $amountString';
  }

  @override
  String get examples => 'EXEMPLES';

  @override
  String memberSince(int year) {
    return 'Membre depuis $year';
  }

  @override
  String get financialHealth => 'Santé Financière';

  @override
  String get excellent => 'Excellent';

  @override
  String get personalInformation => 'Informations Personnelles';

  @override
  String get annualSalary => 'Salaire Annuel';

  @override
  String get weeklyHours => 'Heures Hebdomadaires';

  @override
  String get appPreferences => 'Préférences de l\'Application';

  @override
  String get notifications => 'Notifications';

  @override
  String get darkMode => 'Mode Sombre';

  @override
  String get security => 'Sécurité';

  @override
  String get faceIdLogin => 'Connexion FaceID';

  @override
  String get changePassword => 'Changer le Mot de Passe';

  @override
  String get timeValue => 'Valeur du Temps';

  @override
  String get yourProfileShared => 'VOTRE PROFIL (Partagé)';

  @override
  String get monthlySalary => 'Salaire Mensuel';

  @override
  String get recalculateRate => 'Recalculer le Taux';

  @override
  String get yourTimeIsWorth => 'Votre temps vaut';

  @override
  String get tlPhr => '/h';

  @override
  String get howMuchLife => 'COMBIEN DE VIE CELA COÛTE-T-IL ?';

  @override
  String get trends => 'Tendances';

  @override
  String get noTransactionsYet => 'Aucune transaction pour le moment.';

  @override
  String get good => 'Bien';

  @override
  String get okay => 'Correct';

  @override
  String get regret => 'Regret';

  @override
  String get overBudget => 'Hors Budget';

  @override
  String get onTrack => 'En Bonne Voie';

  @override
  String get monthlyAvg => 'MOY. MENSUELLE';

  @override
  String get day => 'Jour';

  @override
  String get perDay => '/ jour';

  @override
  String days(int count) {
    return '$count Jours';
  }

  @override
  String get financialCoach => 'Coach Financier';

  @override
  String get moodVsMoney => 'Humeur vs Argent';

  @override
  String get needVsWant => 'Besoin vs Désir';

  @override
  String deleteCategoryTitle(String category) {
    return 'Supprimer \"$category\" ?';
  }

  @override
  String get deleteCategoryContent =>
      'Cela retirera uniquement la catégorie de votre liste. Les transactions existantes conserveront ce nom de catégorie.';

  @override
  String get remaining => 'Restant';

  @override
  String goal(double amount) {
    final intl.NumberFormat amountNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String amountString = amountNumberFormat.format(amount);

    return 'OBJECTIF : $amountString';
  }

  @override
  String get transactionHistory => 'Historique des Transactions';

  @override
  String get currency => 'Devise';

  @override
  String get editTransactionTitle => 'Modifier la Transaction';

  @override
  String get titleLabel => 'Titre';

  @override
  String get amountLabel => 'Montant';

  @override
  String get favorite => 'Favori';

  @override
  String get need => 'Besoin';

  @override
  String get want => 'Envie';

  @override
  String get necessity => 'Obligation';

  @override
  String get spendingBalance => 'Solde des Dépenses';

  @override
  String get emotionalImpact => 'Impact Émotionnel';

  @override
  String get budgetProgress => 'Progression du Budget';

  @override
  String get weeklyLimit => 'Limite Hebdomadaire';

  @override
  String get monthlyLimit => 'Limite Mensuelle';

  @override
  String get underDailyGoal => 'sous l\'objectif quotidien';

  @override
  String get overDailyGoal => 'au-dessus de l\'objectif quotidien';

  @override
  String get fancyLatte => 'Latte de Luxe';

  @override
  String get runningShoes => 'Chaussures de Course';

  @override
  String get flagshipPhone => 'Téléphone Haut de Gamme';

  @override
  String get sedanCar => 'Voiture Berline';

  @override
  String get catFood => 'Nourriture';

  @override
  String get catTransport => 'Transport';

  @override
  String get catShopping => 'Achats';

  @override
  String get catFun => 'Plaisir';

  @override
  String get catBills => 'Factures';

  @override
  String get catOther => 'Autre';

  @override
  String get phone => 'Téléphone';

  @override
  String get undoTransactionQuestion =>
      'Voulez-vous annuler cette transaction ?';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get addNote => 'Ajouter une Note';

  @override
  String get enterNote => 'Entrez votre note ici...';

  @override
  String get budgetPlanner => 'Planificateur de Budget';

  @override
  String get pleaseEnterItemAndPrice => 'Veuillez entrer l\'article et le prix';

  @override
  String get victorySaved => 'Victoire Enregistrée ! 🎉';

  @override
  String get editGoal => 'Modifier l\'Objectif';

  @override
  String get goalName => 'Nom de l\'Objectif';

  @override
  String get goalAmount => 'Montant de l\'Objectif';

  @override
  String get rateUpdated => 'Taux Mis à Jour ! 🚀';

  @override
  String get coffeeShoesEta => 'Café, Chaussures, etc.';

  @override
  String get howMuchWasIt => 'Combien ça coûtait ?';

  @override
  String get happy => 'Heureux';

  @override
  String get neutral => 'Neutre';

  @override
  String get reclaimed => 'RÉCUPÉRÉ';

  @override
  String get workHours => 'Heures de Travail';

  @override
  String get mountainOfSavings => 'Montagne d\'Épargnes';

  @override
  String levelX(int level) {
    return 'Niveau $level';
  }

  @override
  String get starting => 'Début';

  @override
  String get totalPool => 'Total Pool';

  @override
  String get discretionarySpending => 'Discretionary';

  @override
  String leftToPeak(int percent) {
    return '$percent% avant le sommet';
  }

  @override
  String get recentVictories => 'Victoires Récentes';

  @override
  String get noVictoriesYet => 'Aucune victoire enregistrée pour le moment.';

  @override
  String savedHours(String hours) {
    return '$hours heures récupérées';
  }

  @override
  String get edit => 'Modifier';

  @override
  String get editVictory => 'Modifier la Victoire';

  @override
  String get minShort => 'm';

  @override
  String get hrShort => 'h';

  @override
  String get workDay => 'jour de travail';

  @override
  String get monthShort => 'month';

  @override
  String get workShort => 'travail';

  @override
  String get categories => 'Catégories';

  @override
  String get weekly => 'Par semaine';

  @override
  String get monthly => 'Mensuel';

  @override
  String get yearly => 'Annuel';

  @override
  String get goals => 'Goals';

  @override
  String get noSpendToast => 'Dépenses enregistrées aujourd\'hui!';

  @override
  String get noSpendTitle => 'Aucune dépense';

  @override
  String get noSpendNote => 'Aucune dépense n\'a été faite aujourd\'hui';

  @override
  String get deletedData => 'Données supprimées';

  @override
  String get settingsAndPreferences => 'PARAMÈTRES ET PRÉFÉRENCES';

  @override
  String get account => 'Compte';

  @override
  String get profileNameLabel => 'NOM DU PROFIL';

  @override
  String get avatarLabel => 'AVATAR';

  @override
  String get personalizeCharacter => 'Personnalisez votre personnage';

  @override
  String get changeAvatar => 'CHANGER L\'AVATAR';

  @override
  String get balanceAndFinance => 'Solde et Finance';

  @override
  String get balanceInfoLabel => 'INFO DU SOLDE';

  @override
  String currentBalance(String amount) {
    return 'ACTUEL: $amount';
  }

  @override
  String get currencyLabel => 'DEVISE';

  @override
  String get appearance => 'Apparence';

  @override
  String get languageSelectionLabel => 'SÉLECTION DE LANGUE';

  @override
  String get themesLabel => 'THÈMES';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeForest => 'Vert Forêt';

  @override
  String get themeCottonCandy => 'Barbe à Papa';

  @override
  String get themeSunset => 'Coucher de Soleil';

  @override
  String get themeProfileDark => 'Bleu Nuit';

  @override
  String get themeAmoled => 'Sombre';

  @override
  String get preferences => 'Préférences';

  @override
  String get hideSpentMoney => 'CACHER L\'ARGENT DÉPENSÉ';

  @override
  String get privacyMode => 'Mode privé';

  @override
  String get needWantModule => 'MODULE BESOIN - ENVIE';

  @override
  String get showWhenAddingNew => 'Afficher lors de l\'ajout';

  @override
  String get emotionModule => 'MODULE ÉMOTION';

  @override
  String get view3D => 'VUE 3D';

  @override
  String get addEmbossEffect => 'Ajouter un effet de relief';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get deleteAll => 'TOUT SUPPRIMER';

  @override
  String get deletePermanently => 'Supprimer toutes les données';

  @override
  String get buttonDelete => 'SUPPRIMER';

  @override
  String get about => 'À propos';

  @override
  String get appPurpose => 'BUT DE L\'APPLICATION';

  @override
  String get whyAreWeHere => 'Pourquoi sommes-nous ici?';

  @override
  String get aboutApp => 'À PROPOS DE L\'APPLICATION';

  @override
  String get versionAndDetails => 'Version et détails';

  @override
  String get creators => 'CRÉATEURS';

  @override
  String get whoDevelopedIt => 'Qui l\'a développé?';

  @override
  String get selectAvatar => 'Sélectionner un Avatar';

  @override
  String get editPhoto => 'Modifier la Photo';

  @override
  String get statistics => 'Statistiques';

  @override
  String get highestStreak => 'PLUS LONGUE SÉRIE';

  @override
  String get totalSpending => 'DÉPENSES TOTALES';

  @override
  String get currentStreakLabel => 'SÉRIE ACTUELLE';

  @override
  String get financialIq => 'QI Financier';

  @override
  String percentNeed(int percent) {
    return '$percent% Besoin';
  }

  @override
  String percentWant(int percent) {
    return '$percent% Envie';
  }

  @override
  String percentObligation(int percent) {
    return '$percent% Oblig.';
  }

  @override
  String get subscriptions => 'Abonnements';

  @override
  String get seeAll => 'VOIR TOUT';

  @override
  String get noSubscriptionsYet => 'Vous n\'avez pas encore d\'abonnements.';

  @override
  String get badgesAndAchievements => 'Badges et Réussites';

  @override
  String get accountOperations => 'Opérations du Compte';

  @override
  String get addIncome => 'Ajouter un Revenu';

  @override
  String get unexpectedMoney => 'De l\'argent inattendu?';

  @override
  String get enterAmount => 'Entrez le montant';

  @override
  String get buttonAdd => 'Ajouter';

  @override
  String get editTotalBalance => 'Modifier le Solde';

  @override
  String get resetInitialBalance => 'Réinitialiser le solde';

  @override
  String get updateBalance => 'Mettre à jour le Solde';

  @override
  String get buttonUpdate => 'Mettre à jour';

  @override
  String get areYouSure => 'Êtes-vous sûr?';

  @override
  String get deleteWarning =>
      'Toutes vos dépenses et paramètres seront supprimés.';

  @override
  String get yesContinue => 'Oui, Continuer';

  @override
  String get finalConfirmation => 'Confirmation Finale';

  @override
  String get pressToClearData => 'Appuyez pour supprimer les données.';

  @override
  String secondsRemaining(int seconds) {
    return '$seconds secondes...';
  }

  @override
  String get deleteNow => 'SUPPRIMER';

  @override
  String get waiting => 'En attente...';

  @override
  String get insightsTitle => 'Aperçus Prédictifs';

  @override
  String get goalUnreachable =>
      'Votre rythme de dépense actuel vous empêche d\'économiser. Objectif inatteignable !';

  @override
  String goalReachableDesc(int days) {
    return 'À votre rythme de dépense actuel, vous atteindrez votre objectif dans environ $days jours.';
  }

  @override
  String budgetEmptyWarning(int days) {
    return 'Attention : À ce rythme de dépense, votre budget sera épuisé dans $days jours !';
  }

  @override
  String get budgetSafe =>
      'Votre budget est en sécurité au rythme de dépense actuel.';

  @override
  String get dailyAverageSavings => 'Épargne Moyenne Quotidienne';

  @override
  String get accountActions => 'Actions du Compte';

  @override
  String get addIncomeDesc => 'Avez-vous reçu de l\'argent inattendu ?';

  @override
  String get noNoteAttached => 'Aucune note';

  @override
  String get categoryDistribution => 'Répartition par Catégorie';

  @override
  String get balanceSummary => 'Résumé du Solde';

  @override
  String get remainingBalanceText => 'Solde Restant';

  @override
  String categoryBudgetShare(String percentage) {
    return 'Part du Budget : $percentage%';
  }

  @override
  String get spentAmount => 'Dépensé';

  @override
  String lastMonthPlus(String diff) {
    return 'Mois dernier: +$diff%';
  }

  @override
  String lastMonthMinus(String diff) {
    return 'Mois dernier: $diff%';
  }

  @override
  String get sameAsLastMonth => 'Identique au mois dernier';

  @override
  String get newData => 'Nouvelles données';

  @override
  String get obligationWarning =>
      'C\'est une dépense obligatoire. Elle n\'affecte pas votre limite quotidienne, déduite uniquement de votre solde principal.';

  @override
  String get tapForDetails => 'Appuyez pour plus de détails';

  @override
  String transactionCount(String count) {
    return '$count Transactions';
  }

  @override
  String get noRecordsToday => 'Aucun enregistrement pour ce jour.';

  @override
  String get goalCurrentGoal => 'Objectif Actuel';

  @override
  String get goalTotalSavings => 'Économies Totales (En Coffre)';

  @override
  String get goalThisMonthTask => 'Tâche du Mois (Protégée)';

  @override
  String get goalRemainingNet => 'Objectif Restant';

  @override
  String get goalIfProtected => 'Si Protégé Ce Mois-ci';

  @override
  String get goalUpdateBtn => 'Mettre à jour';

  @override
  String get goalAddBtn => 'Ajouter';

  @override
  String get goalBalanceAction => 'Action de Solde';

  @override
  String get goalWithdrawMoney => 'Retirer';

  @override
  String get goalEnterAmountHint => 'Entrez le montant (ex. 500)';

  @override
  String get goalWithdrawBtn => 'Retirer';

  @override
  String get goalSpendingPower => 'Pouvoir d\'Achat';

  @override
  String get goalDailyLimit => 'Limite Quotidienne';

  @override
  String get goalOnTarget => 'Objectif Quotidien Atteint';

  @override
  String get goalLimitExceeded => 'Limite Dépassée';

  @override
  String get goalEditPlan => 'Modifier le Plan Financier';

  @override
  String get goalDistributable => 'Distribuable';

  @override
  String get goalMonthlyTarget => 'Objectif Mensuel';

  @override
  String get goalDaily => 'Quotidien';

  @override
  String get goalResetTitle => 'Réinitialiser l\'Objectif ?';

  @override
  String get goalResetDesc =>
      'Êtes-vous sûr de vouloir réinitialiser votre objectif actuel et tout ce que vous avez économisé ? Cette action ne peut être annulée.';

  @override
  String get goalCancelBtn => 'Annuler';

  @override
  String get goalResetSuccessMsg => 'Objectif et économies réinitialisés.';

  @override
  String get goalResetBtn => 'Réinitialiser';

  @override
  String get goalUpdateGoalTitle => 'Mettre à jour l\'objectif';

  @override
  String get goalNameInputLabel => 'Nom de l\'article';

  @override
  String get goalTargetPrice => 'Prix cible';

  @override
  String get goalSaveBtn => 'Enregistrer';

  @override
  String get goalUpdateGoalsTitle => 'Mettre à jour les objectifs';

  @override
  String get goalMonthlySavingsTarget => 'Objectif d\'épargne mensuel';

  @override
  String get shadowItemHint => 'ex: Café, écouteurs...';

  @override
  String get badgeKutsalSeriTitle => 'La Série Sacrée';

  @override
  String get badgeKutsalSeriDesc => 'Nombre de jours consécutifs sans dépense.';

  @override
  String get badgeCuzdanBekcisiTitle => 'Gardien du Portefeuille';

  @override
  String get badgeCuzdanBekcisiDesc =>
      'Nombre total de jours sans aucune dépense.';

  @override
  String get badgeDuyguDedektifiTitle => 'Détective Émotionnel';

  @override
  String get badgeDuyguDedektifiDesc =>
      'Nombre total de transactions enregistrées avec une émotion.';

  @override
  String get badgeDuzenUzmaniTitle => 'Expert en Équilibre';

  @override
  String get badgeDuzenUzmaniDesc =>
      'Nombre total de transactions classées comme besoin, envie ou obligation.';

  @override
  String get badgeVeriKurduTitle => 'Mordu de Données';

  @override
  String get badgeVeriKurduDesc =>
      'Nombre total de transactions de dépenses enregistrées.';

  @override
  String get badgeVazgecisUstasiTitle => 'Maître du Renoncement';

  @override
  String get badgeVazgecisUstasiDesc =>
      'Nombre total d\'articles abandonnés et envoyés au budget fantôme.';

  @override
  String get badgeGallery => 'Galerie de Badges';

  @override
  String get totalProgress => 'Progression Totale';

  @override
  String get totalLevels => 'Niveaux Totaux';

  @override
  String get maxShort => 'MAX';

  @override
  String get levelShort => 'NIV';

  @override
  String get streakBadge => '🔥 Badge de Série';

  @override
  String get cumulativeBadge => '📈 Badge Cumulatif';

  @override
  String get maxLevelReached => 'NIVEAU MAXIMUM ATTEINT !';

  @override
  String get subscriptionManagement => 'Gestion des Abonnements';

  @override
  String get monthlyTotalLabel => 'Total Mensuel';

  @override
  String get expenseDistribution => 'Répartition des Dépenses';

  @override
  String get detailsButton => 'Détails';

  @override
  String get mySubscriptions => 'Mes Abonnements';

  @override
  String onDate(String date) {
    return 'le $date';
  }

  @override
  String get addNewSubscription => 'Ajouter un Abonnement';

  @override
  String get noSubscriptionsAdded =>
      'Vous n\'avez pas encore ajouté d\'abonnement.';

  @override
  String nextLevelTarget(int count) {
    return 'Objectif pour le niveau suivant :\nIl vous en reste $count à faire.';
  }

  @override
  String progressLabel(int current, int total) {
    return 'Progression : $current / $total';
  }

  @override
  String get monthlyReport => 'Rapport Mensuel';

  @override
  String get totalSpent => 'TOTAL DÉPENSÉ';

  @override
  String comparedToLastMonth(String percentage, String trend) {
    return '%$percentage en $trend par rapport au mois dernier';
  }

  @override
  String get trendLess => 'moins';

  @override
  String get trendMore => 'plus';

  @override
  String get subscriptionDistribution => 'Répartition des Abonnements';

  @override
  String get upcomingPayments => 'Paiements à Venir';

  @override
  String get noUpcomingPayments => 'Aucun paiement à venir.';

  @override
  String nextPaymentInDays(int days) {
    return 'PROCHAIN • $days JOURS RESTANTS';
  }

  @override
  String get unknown => 'Inconnu';

  @override
  String daysRemainingText(int days) {
    return 'Il reste $days jours';
  }

  @override
  String get editSubscription => 'Modifier l\'Abonnement';

  @override
  String get newSubscription => 'Nouvel Abonnement';

  @override
  String get serviceIconLabel => 'ICÔNE DU SERVICE';

  @override
  String get serviceNameLabel => 'NOM DU SERVICE';

  @override
  String get serviceNameHint => 'Ex: Netflix, Spotify...';

  @override
  String get monthlyFeeLabel => 'FRAIS MENSUELS';

  @override
  String get paymentCycleLabel => 'CYCLE DE PAIEMENT';

  @override
  String get wantNeedLabel => 'ENVIE / BESOIN';

  @override
  String get needItem => 'Besoin';

  @override
  String get wantItem => 'Envie';

  @override
  String get necessityItem => 'Nécessité';

  @override
  String get moodLabel => 'HUMEUR';

  @override
  String get happyItem => 'Heureux';

  @override
  String get neutralItem => 'Neutre';

  @override
  String get regretItem => 'Regret';

  @override
  String get nextPaymentDateLabel => 'PROCHAINE DATE DE PAIEMENT';

  @override
  String get dateHint => 'jj.mm.aaaa';

  @override
  String get unnamed => 'Sans nom';

  @override
  String get notSpecified => 'Non spécifié';

  @override
  String get saveChanges => 'ENREGISTRER LES MODIFICATIONS';

  @override
  String get saveSubscription => 'ENREGISTRER L\'ABONNEMENT';

  @override
  String get deleteSubscription => 'SUPPRIMER L\'ABONNEMENT';

  @override
  String get editMyIcon => 'Modifier Mon Icône';

  @override
  String get customIcon => 'Icône Personnalisée';

  @override
  String get selectIconTitle => 'Sélectionner Une Icône';

  @override
  String get uploadIcon => 'TÉLÉCHARGER L\'ICÔNE';

  @override
  String get popularCategory => 'Populaire';

  @override
  String get financeCategory => 'Finance';

  @override
  String get educationCategory => 'Éducation';

  @override
  String get entertainmentCategory => 'Divertissement';

  @override
  String get bankWord => 'Banque';

  @override
  String get insuranceWord => 'Assurance';

  @override
  String get creditCardWord => 'Carte de Crédit';

  @override
  String get creditWord => 'Crédit';

  @override
  String get schoolWord => 'École';

  @override
  String get bookMagazineWord => 'Livre/Magazine';

  @override
  String get personalDevWord => 'Développement Personnel';

  @override
  String get courseWord => 'Cours';

  @override
  String get gameWord => 'Jeu';

  @override
  String get cinemaSeriesWord => 'Cinéma/Série';

  @override
  String get musicWord => 'Musique';

  @override
  String get eventActivityWord => 'Événement';

  @override
  String get totalUppercase => 'TOTAL';

  @override
  String get spendingsTab => 'Dépenses';

  @override
  String get otherCategory => 'Autre';

  @override
  String get autoRenewal => 'Renouvellement Automatique';

  @override
  String get appPurposeHeroTitle => 'Dépense Consciente,\nAvenir Libre.';

  @override
  String get appPurposeHeroDesc =>
      'Pretio transforme vos dépenses de simples chiffres en leur véritable impact sur votre vie, vous aidant à remplacer les pulsions par des décisions conscientes qui vous rapprochent de vos rêves.';

  @override
  String get feature1Title => 'Saisie Rapide et Pratique';

  @override
  String get feature1Desc =>
      'Enregistrez vos dépenses instantanément et sans effort. Oubliez les formulaires fastidieux, ajoutez vos transactions en quelques secondes et faites du suivi financier une habitude quotidienne agréable.';

  @override
  String get feature2Title => 'Boussole Financière Émotionnelle';

  @override
  String get feature2Desc =>
      'Découvrez la psychologie derrière chaque dépense. Est-ce un vrai besoin ou une pulsion ? Cartographiez vos habitudes de consommation et allouez votre argent uniquement à ce qui vous apporte de la valeur.';

  @override
  String get feature3Title => 'Concentrez-vous sur vos Rêves';

  @override
  String get feature3Desc =>
      'Planifiez non seulement pour aujourd\'hui, mais pour demain. Voyez clairement à quel point vous êtes proche de votre objectif et dirigez vos économies vers celui-ci.';

  @override
  String get feature4Title => 'Analyse Détaillée et Suivi des Habitudes';

  @override
  String get feature4Desc =>
      'Voyez de manière transparente où va votre argent. Découvrez vos habitudes de consommation en examinant en détail vos tendances et votre répartition émotionnelle avec des graphiques élégants.';

  @override
  String get feature5Title => 'Entièrement Personnalisable';

  @override
  String get feature5Desc =>
      'Personnalisez votre assistant financier selon votre style de vie. Créez vos catégories, définissez vos montants rapides et célébrez vos succès avec des badges.';

  @override
  String get aboutHeroDesc =>
      'Pretio n\'est pas un simple outil de suivi de budget ; c\'est une philosophie de vie qui vous redonne le contrôle de votre temps, de votre argent et de vos émotions. Au milieu de la frénésie de la consommation, il a été conçu pour vous rappeler votre propre volonté et éclairer le chemin vers vos rêves.';

  @override
  String get aboutSection1Title => 'Signification du Nom';

  @override
  String get aboutSection1Desc =>
      'Pretio tire ses racines du mot latin \"pretium\", qui signifie \"valeur\" et \"prix\". Tout ce que nous achetons dans la vie a non seulement un coût financier, mais aussi un vrai prix payé avec notre temps et nos émotions. Pretio existe pour vous montrer cette vraie valeur.';

  @override
  String get aboutSection2Title => 'Sa Simplicité';

  @override
  String get aboutSection2Desc =>
      'Il ne vous submerge pas de tableaux financiers complexes, de menus déroutants ou de graphiques épuisants. Avec son design minimaliste et reposant pour les yeux, il transforme le suivi financier en une routine paisible.';

  @override
  String get aboutSection3Title => 'Sa Conscience';

  @override
  String get aboutSection3Desc =>
      'Il ne vous montre pas seulement ce que vous dépensez, mais pourquoi vous le dépensez. En éclairant votre psychologie de consommation, il vous aide à comprendre si l\'article est un vrai besoin ou un caprice.';

  @override
  String get aboutSection4Title => 'Sa Praticité';

  @override
  String get aboutSection4Desc =>
      'Il suit parfaitement le rythme de la vie quotidienne. Vous pouvez saisir des dépenses en quelques secondes sans remplir de longs formulaires, mettre à jour votre budget d\'un geste et résumer votre statut d\'un coup d\'œil.';

  @override
  String get aboutSection5Title => 'Sa Personnalisation';

  @override
  String get aboutSection5Desc =>
      'Le style de vie et le parcours financier de chacun sont uniques. Vous pouvez adapter entièrement Pretio à vos propres habitudes en créant vos catégories, en fixant des objectifs personnalisés et en configurant vos montants.';

  @override
  String get aboutFooterNote =>
      'Cette application a été créée par un groupe de développeurs indépendants pour vous aider à protéger votre force de volonté contre la frénésie de la consommation.';

  @override
  String get developersTitle => 'Nos Développeurs';

  @override
  String get averageSoFar => 'Moyenne jusqu\'à présent';

  @override
  String get all => 'Tout';

  @override
  String get favorites => 'Favoris';

  @override
  String get currentNetBalance => 'Solde Net Actuel';

  @override
  String get makeTransaction => 'Faire une Transaction';

  @override
  String get expense => 'Expense';

  @override
  String get income => 'Income';

  @override
  String insightProjectionGood(String percent) {
    return 'À ce rythme, vous économiserez $percent % de plus que votre objectif à la fin du mois.';
  }

  @override
  String insightProjectionBad(String percent) {
    return 'À ce rythme, vous économiserez $percent % de moins que votre objectif à la fin du mois.';
  }

  @override
  String insightCategoryAlert(String category) {
    return 'Vous avez dépensé le plus dans la catégorie $category ce mois-ci.';
  }

  @override
  String insightStreak(int days) {
    return 'Super ! Vous n\'avez rien dépensé pendant $days jours.';
  }
}

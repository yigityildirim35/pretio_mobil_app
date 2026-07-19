// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Zaman Maliyeti Hesaplayıcı';

  @override
  String get balance => 'Bakiye';

  @override
  String get dashboard => 'Panel';

  @override
  String get calendar => 'Takvim';

  @override
  String get reports => 'Raporlar';

  @override
  String get settings => 'Ayarlar';

  @override
  String get theme => 'Tema';

  @override
  String get language => 'Dil';

  @override
  String get selectLanguage => 'Dil Seçin';

  @override
  String get today => 'Bugün';

  @override
  String get yesterday => 'Dün';

  @override
  String get analytics => 'Analiz';

  @override
  String get coach => 'Asistan';

  @override
  String get shadow => 'Gölge';

  @override
  String get time => 'Zaman';

  @override
  String get profile => 'Profil';

  @override
  String get setDailyGoal => 'Günlük Hedef Belirle';

  @override
  String get addQuickAmount => 'Hızlı Tutar Ekle';

  @override
  String get needs => 'İhtiyaçlar';

  @override
  String get wants => 'İstekler';

  @override
  String get total => 'Toplam';

  @override
  String get currentStreak => 'Mevcut Seri';

  @override
  String get longestStreak => 'En Uzun Seri';

  @override
  String get cancel => 'İptal';

  @override
  String get save => 'Kaydet';

  @override
  String get add => 'Ekle';

  @override
  String get delete => 'Sil';

  @override
  String editAmount(double amount) {
    final intl.NumberFormat amountNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String amountString = amountNumberFormat.format(amount);

    return 'Tutarı Düzenle $amountString';
  }

  @override
  String get deleteAmountConfirmation =>
      'Bu hızlı tutarı silmek istiyor musunuz?';

  @override
  String get manage => 'Yönet';

  @override
  String get done => 'Bitti';

  @override
  String get addTransaction => 'İşlem Ekle';

  @override
  String get whatDidYouBuy => 'Ne satın aldın?';

  @override
  String get howDoYouFeel => 'Bunun hakkında ne hissediyorsun?';

  @override
  String get isThisNeedOrWant => 'Bu bir İhtiyaç, İstek veya Zorunluluk mu?';

  @override
  String get saveTransaction => 'İşlemi Kaydet';

  @override
  String get recentActivity => 'Son Hareketler';

  @override
  String get viewAll => 'Tümünü Gör';

  @override
  String get noRecentActivity => 'Henüz hareket yok';

  @override
  String get newCategory => 'Yeni Kategori';

  @override
  String get categoryName => 'Kategori Adı';

  @override
  String get selectIcon => 'İkon Seç';

  @override
  String get selectColor => 'Renk Seç';

  @override
  String get create => 'Oluştur';

  @override
  String get shadowBudget => 'Gölge Bütçe';

  @override
  String get item => 'Ürün';

  @override
  String get price => 'Fiyat';

  @override
  String get howDidItFeel => 'Almamak nasıl hissettirdi?';

  @override
  String get proud => 'Gururlu';

  @override
  String get relieved => 'Rahatlamış';

  @override
  String get sad => 'Üzgün';

  @override
  String get iDidntBuyIt => 'Satın Almadım!';

  @override
  String totalSaved(double amount) {
    final intl.NumberFormat amountNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String amountString = amountNumberFormat.format(amount);

    return 'Toplam Birikim: $amountString';
  }

  @override
  String get examples => 'ÖRNEKLER';

  @override
  String memberSince(int year) {
    return 'Üyelik yılı: $year';
  }

  @override
  String get financialHealth => 'Finansal Sağlık';

  @override
  String get excellent => 'Mükemmel';

  @override
  String get personalInformation => 'Kişisel Bilgiler';

  @override
  String get annualSalary => 'Yıllık Maaş';

  @override
  String get weeklyHours => 'Haftalık Saat';

  @override
  String get appPreferences => 'Uygulama Tercihleri';

  @override
  String get notifications => 'Bildirimler';

  @override
  String get darkMode => 'Karanlık Mod';

  @override
  String get security => 'Güvenlik';

  @override
  String get faceIdLogin => 'FaceID ile Giriş';

  @override
  String get changePassword => 'Şifre Değiştir';

  @override
  String get timeValue => 'Zaman Değeri';

  @override
  String get yourProfileShared => 'PROFİLİNİZ (Paylaşılan)';

  @override
  String get monthlySalary => 'Aylık Maaş';

  @override
  String get recalculateRate => 'Oranı Yeniden Hesapla';

  @override
  String get yourTimeIsWorth => 'Zamanınızın değeri';

  @override
  String get tlPhr => '/sa';

  @override
  String get howMuchLife => 'HAYATINIZDAN NE KADAR GİDİYOR?';

  @override
  String get trends => 'Trendler';

  @override
  String get noTransactionsYet => 'Henüz işlem yok.';

  @override
  String get good => 'İyi';

  @override
  String get okay => 'İdare Eder';

  @override
  String get regret => 'Pişman';

  @override
  String get overBudget => 'Bütçe Aşıldı';

  @override
  String get onTrack => 'Yolunda';

  @override
  String get monthlyAvg => 'AYLIK ORT.';

  @override
  String get day => 'Gün';

  @override
  String get perDay => '/ gün';

  @override
  String days(int count) {
    return '$count Gün';
  }

  @override
  String get financialCoach => 'Finansal Koç';

  @override
  String get moodVsMoney => 'Ruh Hali';

  @override
  String get needVsWant => 'İstek/İhtiyaç';

  @override
  String deleteCategoryTitle(String category) {
    return '\"$category\" kategorisini sil?';
  }

  @override
  String get deleteCategoryContent =>
      'Bu işlem kategoriyi sadece listenizden kaldırır. Mevcut işlemler bu kategori adını koruyacaktır.';

  @override
  String get remaining => 'Kalan';

  @override
  String goal(double amount) {
    final intl.NumberFormat amountNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String amountString = amountNumberFormat.format(amount);

    return 'HEDEF: $amountString';
  }

  @override
  String get transactionHistory => 'İşlem Geçmişi';

  @override
  String get currency => 'Para Birimi';

  @override
  String get editTransactionTitle => 'İşlemi Düzenle';

  @override
  String get titleLabel => 'Başlık';

  @override
  String get amountLabel => 'Tutar';

  @override
  String get favorite => 'Favori';

  @override
  String get need => 'İhtiyaç';

  @override
  String get want => 'İstek';

  @override
  String get necessity => 'Zorunluluk';

  @override
  String get spendingBalance => 'Harcama Dengesi';

  @override
  String get emotionalImpact => 'Duygusal Etki';

  @override
  String get budgetProgress => 'Bütçe İlerlemesi';

  @override
  String get weeklyLimit => 'Haftalık Limit';

  @override
  String get monthlyLimit => 'Aylık Limit';

  @override
  String get underDailyGoal => 'günlük hedefin altında';

  @override
  String get overDailyGoal => 'günlük hedefin üzerinde';

  @override
  String get fancyLatte => 'Lüks Latte';

  @override
  String get runningShoes => 'Koşu Ayakkabısı';

  @override
  String get flagshipPhone => 'Amiral Gemisi Telefon';

  @override
  String get sedanCar => 'Sedan Araba';

  @override
  String get catFood => 'Yemek';

  @override
  String get catTransport => 'Ulaşım';

  @override
  String get catShopping => 'Alışveriş';

  @override
  String get catFun => 'Eğlence';

  @override
  String get catBills => 'Faturalar';

  @override
  String get catOther => 'Diğer';

  @override
  String get phone => 'Telefon';

  @override
  String get undoTransactionQuestion => 'Bu işlemi geri almak ister misiniz?';

  @override
  String get yes => 'Evet';

  @override
  String get no => 'Hayır';

  @override
  String get addNote => 'Not Ekle';

  @override
  String get enterNote => 'Notunuzu buraya girin...';

  @override
  String get budgetPlanner => 'Bütçe Planlayıcı';

  @override
  String get pleaseEnterItemAndPrice => 'Lütfen ürün ve fiyat girin';

  @override
  String get victorySaved => 'Zafer Kaydedildi! 🎉';

  @override
  String get editGoal => 'Hedefi Düzenle';

  @override
  String get goalName => 'Hedef Adı';

  @override
  String get goalAmount => 'Hedef Tutar';

  @override
  String get rateUpdated => 'Oran Güncellendi! 🚀';

  @override
  String get coffeeShoesEta => 'Kahve, Ayakkabı vb.';

  @override
  String get howMuchWasIt => 'Fiyatı ne kadardı?';

  @override
  String get happy => 'Mutlu';

  @override
  String get neutral => 'Nötr';

  @override
  String get reclaimed => 'KAZANILAN';

  @override
  String get workHours => 'İş Saati';

  @override
  String get mountainOfSavings => 'Birikim Dağı';

  @override
  String levelX(int level) {
    return 'Seviye $level';
  }

  @override
  String get starting => 'Başlangıç';

  @override
  String get totalPool => 'Toplam Kasa';

  @override
  String get discretionarySpending => 'Zorunluluk Dışı';

  @override
  String leftToPeak(int percent) {
    return 'Zirveye %$percent kaldı';
  }

  @override
  String get recentVictories => 'Son Zaferler';

  @override
  String get noVictoriesYet => 'Henüz bir zafer kaydedilmedi.';

  @override
  String savedHours(String hours) {
    return '$hours saat kurtarıldı';
  }

  @override
  String get edit => 'Düzenle';

  @override
  String get editVictory => 'Zaferi Düzenle';

  @override
  String get minShort => 'dk';

  @override
  String get hrShort => 'sa';

  @override
  String get workDay => 'iş günü';

  @override
  String get monthShort => 'month';

  @override
  String get workShort => 'çalışma';

  @override
  String get categories => 'Kategoriler';

  @override
  String get weekly => 'Haftalık';

  @override
  String get monthly => 'Aylık';

  @override
  String get yearly => 'Yıllık';

  @override
  String get goals => 'Hedefler';

  @override
  String get noSpendToast => 'Bugün harcama yapıldı!';

  @override
  String get noSpendTitle => 'Harcama yapılmadı';

  @override
  String get noSpendNote => 'Bugün hiç harcama yapılmadı';

  @override
  String get deletedData => 'Silinen Veri';

  @override
  String get settingsAndPreferences => 'AYARLAR VE TERCİHLER';

  @override
  String get account => 'Hesap';

  @override
  String get profileNameLabel => 'PROFİL İSMİ';

  @override
  String get avatarLabel => 'AVATAR';

  @override
  String get personalizeCharacter => 'Karakterini kişiselleştir';

  @override
  String get changeAvatar => 'AVATAR DEĞİŞTİR';

  @override
  String get balanceAndFinance => 'Bakiye ve Finans';

  @override
  String get balanceInfoLabel => 'BAKİYE BİLGİSİ';

  @override
  String currentBalance(String amount) {
    return 'GÜNCEL: $amount';
  }

  @override
  String get currencyLabel => 'PARA BİRİMİ';

  @override
  String get appearance => 'Görünüm';

  @override
  String get languageSelectionLabel => 'DİL SEÇİMİ';

  @override
  String get themesLabel => 'TEMALAR';

  @override
  String get themeLight => 'Açık';

  @override
  String get themeForest => 'Orman Yeşili';

  @override
  String get themeCottonCandy => 'Pamuk Şeker';

  @override
  String get themeSunset => 'Günbatımı';

  @override
  String get themeProfileDark => 'Gece Mavisi';

  @override
  String get themeAmoled => 'Koyu';

  @override
  String get preferences => 'Tercihler';

  @override
  String get hideSpentMoney => 'HARCANAN PARAYI GİZLE';

  @override
  String get privacyMode => 'Gizlilik modu';

  @override
  String get needWantModule => 'İSTEK - İHTİYAÇ MODÜLÜ';

  @override
  String get showWhenAddingNew => 'Yeni işlem eklerken göster';

  @override
  String get emotionModule => 'RUH HALİ MODÜLÜ';

  @override
  String get view3D => '3D GÖRÜNÜM';

  @override
  String get addEmbossEffect => 'Kartlara kabartma efekti ekle';

  @override
  String get reset => 'Sıfırla';

  @override
  String get deleteAll => 'HERŞEYİ SİL';

  @override
  String get deletePermanently => 'Tüm verileri kalıcı olarak sil';

  @override
  String get buttonDelete => 'SİL';

  @override
  String get about => 'Hakkında';

  @override
  String get appPurpose => 'UYGULAMA AMACI';

  @override
  String get whyAreWeHere => 'Neden buradayız?';

  @override
  String get aboutApp => 'UYGULAMA HAKKINDA';

  @override
  String get versionAndDetails => 'Versiyon ve detaylar';

  @override
  String get creators => 'YAPIMCILAR';

  @override
  String get whoDevelopedIt => 'Kimler geliştirdi?';

  @override
  String get selectAvatar => 'Avatar Seç';

  @override
  String get editPhoto => 'Fotoğrafı Düzenle';

  @override
  String get statistics => 'İstatistikler';

  @override
  String get highestStreak => 'EN İYİ SERİ';

  @override
  String get totalSpending => 'TOPLAM HARCAMA';

  @override
  String get currentStreakLabel => 'GÜNCEL SERİ';

  @override
  String get financialIq => 'Finansal IQ';

  @override
  String percentNeed(int percent) {
    return '%$percent İhtiyaç';
  }

  @override
  String percentWant(int percent) {
    return '%$percent İstek';
  }

  @override
  String percentObligation(int percent) {
    return '%$percent Zorunluluk';
  }

  @override
  String get subscriptions => 'Abonelikler';

  @override
  String get seeAll => 'TÜMÜNÜ GÖR';

  @override
  String get noSubscriptionsYet => 'Henüz abonelik eklemediniz.';

  @override
  String get badgesAndAchievements => 'Rozetler & Başarılar';

  @override
  String get accountOperations => 'Hesap İşlemleri';

  @override
  String get addIncome => 'Gelir Ekle';

  @override
  String get unexpectedMoney => 'Beklenmedik bir para mı geldi?';

  @override
  String get enterAmount => 'Miktar girin';

  @override
  String get buttonAdd => 'Ekle';

  @override
  String get editTotalBalance => 'Toplam Bakiyeyi Düzenle';

  @override
  String get resetInitialBalance => 'Başlangıç bakiyesini sıfırla';

  @override
  String get updateBalance => 'Toplam Bakiyeyi Güncelle';

  @override
  String get buttonUpdate => 'Güncelle';

  @override
  String get areYouSure => 'Emin misiniz?';

  @override
  String get deleteWarning =>
      'Tüm harcamalarınız, abonelikleriniz ve ayarlarınız kalıcı olarak silinecektir. Bu işlem geri alınamaz.';

  @override
  String get yesContinue => 'Evet, Devam Et';

  @override
  String get finalConfirmation => 'Son Onay';

  @override
  String get pressToClearData => 'Verileri silmek için butona basın.';

  @override
  String secondsRemaining(int seconds) {
    return '$seconds saniye...';
  }

  @override
  String get deleteNow => 'ŞİMDİ SİL';

  @override
  String get waiting => 'Bekleniyor...';

  @override
  String get insightsTitle => 'Gelecek Öngörüleri';

  @override
  String get goalUnreachable =>
      'Mevcut harcama hızınız tasarruf etmenizi engelliyor. Hedefinize ulaşılamıyor!';

  @override
  String goalReachableDesc(int days) {
    return 'Mevcut harcama hızınızla, hedefinize yaklaşık $days gün içinde ulaşacaksınız.';
  }

  @override
  String budgetEmptyWarning(int days) {
    return 'Uyarı: Bu harcama hızında bütçeniz $days gün içinde tükenecek!';
  }

  @override
  String get budgetSafe => 'Mevcut harcama hızınızda bütçeniz güvende.';

  @override
  String get dailyAverageSavings => 'Günlük Ortalama Birikim';

  @override
  String get accountActions => 'Hesap İşlemleri';

  @override
  String get addIncomeDesc => 'Beklenmedik bir para mı geldi?';

  @override
  String get noNoteAttached => 'Not eklenmemiş';

  @override
  String get categoryDistribution => 'Kategori Dağılımı';

  @override
  String get balanceSummary => 'Bakiye Özeti';

  @override
  String get remainingBalanceText => 'Kalan Bakiye';

  @override
  String categoryBudgetShare(String percentage) {
    return 'Bütçe Payı: %$percentage';
  }

  @override
  String get spentAmount => 'Harcanan';

  @override
  String lastMonthPlus(String diff) {
    return 'Geçen ay: +%$diff';
  }

  @override
  String lastMonthMinus(String diff) {
    return 'Geçen ay: %$diff';
  }

  @override
  String get sameAsLastMonth => 'Geçen ay ile aynı';

  @override
  String get newData => 'Yeni Veri';

  @override
  String get obligationWarning =>
      'Bu zorunlu bir harcamadır. Günlük limitinizi etkilemedi, yalnızca kalan ana bakiyenizden düşüldü.';

  @override
  String get tapForDetails => 'Detaylar için dokunun';

  @override
  String transactionCount(String count) {
    return '$count İşlem';
  }

  @override
  String get noRecordsToday => 'Bu gün için kayıt yok.';

  @override
  String get goalCurrentGoal => 'Şu anki Hedef';

  @override
  String get goalTotalSavings => 'Toplam Birikim (Kasadaki)';

  @override
  String get goalThisMonthTask => 'Bu Ayki Görev (Korunan)';

  @override
  String get goalRemainingNet => 'Kalan Hedef';

  @override
  String get goalIfProtected => 'Bu Ay Korunursa';

  @override
  String get goalUpdateBtn => 'Güncelle';

  @override
  String get goalAddBtn => 'Ekle';

  @override
  String get goalBalanceAction => 'Bakiye İşlemi';

  @override
  String get goalWithdrawMoney => 'Para Çek';

  @override
  String get goalEnterAmountHint => 'Miktar girin (örn. 500)';

  @override
  String get goalWithdrawBtn => 'Çek';

  @override
  String get goalSpendingPower => 'Harcama Gücü';

  @override
  String get goalDailyLimit => 'Günlük Limit';

  @override
  String get goalOnTarget => 'Günlük Hedefte';

  @override
  String get goalLimitExceeded => 'Limit Aşıldı';

  @override
  String get goalEditPlan => 'Finansal Planı Düzenle';

  @override
  String get goalDistributable => 'Harcanabilir';

  @override
  String get goalMonthlyTarget => 'Aylık Hedef';

  @override
  String get goalDaily => 'Günlük';

  @override
  String get goalResetTitle => 'Hedefi Sıfırla?';

  @override
  String get goalResetDesc =>
      'Mevcut hedefinizi ve biriktirdiğiniz tüm tutarı sıfırlamak istediğinize emin misiniz? Bu işlem geri alınamaz.';

  @override
  String get goalCancelBtn => 'İptal';

  @override
  String get goalResetSuccessMsg => 'Hedef ve birikimler sıfırlandı.';

  @override
  String get goalResetBtn => 'Sıfırla';

  @override
  String get goalUpdateGoalTitle => 'Hedefi Güncelle';

  @override
  String get goalNameInputLabel => 'Alınacak Şeyin Adı';

  @override
  String get goalTargetPrice => 'Hedef Fiyat';

  @override
  String get goalSaveBtn => 'Kaydet';

  @override
  String get goalUpdateGoalsTitle => 'Hedefleri Güncelle';

  @override
  String get goalMonthlySavingsTarget => 'Aylık Birikim Hedefi';

  @override
  String get shadowItemHint => 'Örn: Kahve, kulaklık...';

  @override
  String get badgeKutsalSeriTitle => 'Kutsal Seri';

  @override
  String get badgeKutsalSeriDesc => 'Harcama yapmadığın kesintisiz gün sayısı.';

  @override
  String get badgeCuzdanBekcisiTitle => 'Cüzdan Bekçisi';

  @override
  String get badgeCuzdanBekcisiDesc =>
      'Hiç harcama yapılmayan toplam gün sayısı.';

  @override
  String get badgeDuyguDedektifiTitle => 'Duygu Dedektifi';

  @override
  String get badgeDuyguDedektifiDesc =>
      'Duygu durumu girilmiş toplam işlem sayısı.';

  @override
  String get badgeDuzenUzmaniTitle => 'Denge Uzmanı';

  @override
  String get badgeDuzenUzmaniDesc =>
      'İhtiyaç, istek veya zorunluluk olarak etiketlenmiş toplam işlem sayısı.';

  @override
  String get badgeVeriKurduTitle => 'Veri Kurdu';

  @override
  String get badgeVeriKurduDesc =>
      'Sisteme girilen toplam harcama işlemi sayısı.';

  @override
  String get badgeVazgecisUstasiTitle => 'Vazgeçiş Ustası';

  @override
  String get badgeVazgecisUstasiDesc =>
      'Almaktan vazgeçilip gölge bütçeye atılan işlem sayısı.';

  @override
  String get badgeGallery => 'Rozet Galerisi';

  @override
  String get totalProgress => 'Toplam İlerleme';

  @override
  String get totalLevels => 'Toplam Seviye';

  @override
  String get maxShort => 'MAX';

  @override
  String get levelShort => 'LVL';

  @override
  String get streakBadge => '🔥 Seri Rozeti';

  @override
  String get cumulativeBadge => '📈 Birikimli Rozet';

  @override
  String get maxLevelReached => 'MAKSİMUM SEVİYE ULAŞILDI!';

  @override
  String get subscriptionManagement => 'Abonelik Yönetimi';

  @override
  String get monthlyTotalLabel => 'Aylık Toplam';

  @override
  String get expenseDistribution => 'Harcama Dağılımı';

  @override
  String get detailsButton => 'Detaylar';

  @override
  String get mySubscriptions => 'Aboneliklerim';

  @override
  String onDate(String date) {
    return '$date tarihinde';
  }

  @override
  String get addNewSubscription => 'Yeni Abonelik Ekle';

  @override
  String get noSubscriptionsAdded => 'Henüz abonelik eklemediniz.';

  @override
  String nextLevelTarget(int count) {
    return 'Bir sonraki seviye için kalan hedef:\n$count adet daha yapmanız gerekiyor.';
  }

  @override
  String progressLabel(int current, int total) {
    return '$current / $total ilerleme';
  }

  @override
  String get monthlyReport => 'Aylık Rapor';

  @override
  String get totalSpent => 'TOPLAM HARCANAN';

  @override
  String comparedToLastMonth(String percentage, String trend) {
    return 'Geçen aya göre %$percentage daha $trend';
  }

  @override
  String get trendLess => 'az';

  @override
  String get trendMore => 'fazla';

  @override
  String get subscriptionDistribution => 'Abonelik Dağılımı';

  @override
  String get upcomingPayments => 'Yaklaşan Ödemeler';

  @override
  String get noUpcomingPayments => 'Yaklaşan ödeme bulunmuyor.';

  @override
  String nextPaymentInDays(int days) {
    return 'SIRADAKİ • $days GÜN KALDI';
  }

  @override
  String get unknown => 'Bilinmiyor';

  @override
  String daysRemainingText(int days) {
    return '$days gün kaldı';
  }

  @override
  String get editSubscription => 'Aboneliği Düzenle';

  @override
  String get newSubscription => 'Yeni Abonelik';

  @override
  String get serviceIconLabel => 'SERVİS SİMGESİ';

  @override
  String get serviceNameLabel => 'SERVİS ADI';

  @override
  String get serviceNameHint => 'Örn: Netflix, Spotify...';

  @override
  String get monthlyFeeLabel => 'AYLIK ÜCRET';

  @override
  String get paymentCycleLabel => 'ÖDEME DÖNGÜSÜ';

  @override
  String get wantNeedLabel => 'İSTEK / İHTİYAÇ';

  @override
  String get needItem => 'İhtiyaç';

  @override
  String get wantItem => 'İstek';

  @override
  String get necessityItem => 'Zorunluluk';

  @override
  String get moodLabel => 'RUH HALİ';

  @override
  String get happyItem => 'Mutlu';

  @override
  String get neutralItem => 'Nötr';

  @override
  String get regretItem => 'Pişman';

  @override
  String get nextPaymentDateLabel => 'SIRADAKİ ÖDEME TARİHİ';

  @override
  String get dateHint => 'gg.aa.yyyy';

  @override
  String get unnamed => 'İsimsiz';

  @override
  String get notSpecified => 'Belirtilmedi';

  @override
  String get saveChanges => 'DEĞİŞİKLİKLERİ KAYDET';

  @override
  String get saveSubscription => 'ABONELİĞİ KAYDET';

  @override
  String get deleteSubscription => 'ABONELİĞİ SİL';

  @override
  String get editMyIcon => 'Simgemi Düzenle';

  @override
  String get customIcon => 'Özel Simge';

  @override
  String get selectIconTitle => 'Simge Seç';

  @override
  String get uploadIcon => 'İCON YÜKLE';

  @override
  String get popularCategory => 'Popüler';

  @override
  String get financeCategory => 'Finans';

  @override
  String get educationCategory => 'Eğitim';

  @override
  String get entertainmentCategory => 'Eğlence';

  @override
  String get bankWord => 'Banka';

  @override
  String get insuranceWord => 'Sigorta';

  @override
  String get creditCardWord => 'Kredi Kartı';

  @override
  String get creditWord => 'Kredi';

  @override
  String get schoolWord => 'Okul';

  @override
  String get bookMagazineWord => 'Kitap/Dergi';

  @override
  String get personalDevWord => 'Kişisel Gelişim';

  @override
  String get courseWord => 'Kurs';

  @override
  String get gameWord => 'Oyun';

  @override
  String get cinemaSeriesWord => 'Sinema/Dizi';

  @override
  String get musicWord => 'Müzik';

  @override
  String get eventActivityWord => 'Etkinlik';

  @override
  String get totalUppercase => 'TOPLAM';

  @override
  String get spendingsTab => 'Harcamalar';

  @override
  String get otherCategory => 'Diğer';

  @override
  String get autoRenewal => 'Otomatik Yenileme';

  @override
  String get appPurposeHeroTitle => 'Bilinçli Harcama,\nÖzgür Gelecek.';

  @override
  String get appPurposeHeroDesc =>
      'Pretio, harcamalarınızı birer rakam olmaktan çıkarıp hayatınızdaki gerçek etkisini size göstermek ve anlık dürtülerin yerini, sizi hayallerinize ulaştıracak bilinçli kararların almasını sağlamaktır.';

  @override
  String get feature1Title => 'Hızlı ve Pratik Kayıt';

  @override
  String get feature1Desc =>
      'Harcamalarınızı aninda ve zahmetsizce kaydedin. Sıkıcı formlar yerine saniyeler içinde işleminizi ekleyerek finansal takibi keyifli bir günlük alışkanlığa dönüştürün.';

  @override
  String get feature2Title => 'Duygusal Finans Pusulası';

  @override
  String get feature2Desc =>
      'Her harcamanın arkasındaki psikolojiyi keşfedin. Gerçek bir ihtiyaç mı, anlık bir dürtü mü? Tüketim psikolojinizi haritalandırarak paranızı sadece size değer katan şeylere ayırın.';

  @override
  String get feature3Title => 'Hayallerinize Odaklanın';

  @override
  String get feature3Desc =>
      'Sadece bugünü değil, geleceği planlayın. Hayalini kurduğunuz hedefe ne kadar yaklaştığınızı net bir şekilde görün ve birikimlerinizi doğrudan hedefinize yönlendirin.';

  @override
  String get feature4Title => 'Detaylı Analiz ve Alışkanlık Takibi';

  @override
  String get feature4Desc =>
      'Paranızın nereye gittiğini şeffaf bir şekilde görün. Harcama eğilimlerinizi ve duygu durumlarınıza göre dağılımı şık grafiklerle detaylıca inceleyerek tüketim alışkanlıklarınızı keşfedin.';

  @override
  String get feature5Title => 'Tamamen Kişiselleştirilebilir';

  @override
  String get feature5Desc =>
      'Finansal asistanınızı kendi hayat tarzınıza göre şekillendirin. Kendi kategorilerinizi oluşturun, hızlı giriş tutarlarınızı belirleyin ve size özel rozetlerle başarılarınızı kutlayın.';

  @override
  String get aboutHeroDesc =>
      'Pretio, sıradan bir bütçe takip aracı değil; zamanınızın, paranızın ve duygularınızın kontrolünü size geri veren kişisel bir yaşam felsefesidir. Tüketim çılgınlığının ortasında, size kendi iradenizi hatırlatmak ve hayallerinize giden yolu aydınlatmak için tasarlandı.';

  @override
  String get aboutSection1Title => 'İsminin Anlamı';

  @override
  String get aboutSection1Desc =>
      'Pretio, kökenini Latince \"değer\", \"kıymet\" ve \"bedel\" anlamlarına gelen pretium kelimesinden alır. Hayatta satın aldığımız her şeyin sadece cüzdanımızdan çıkan bir fiyatı değil; zamanımızdan ve duygularımızdan ödediğimiz gerçek bir bedeli var. Pretio, size bu gerçek değeri göstermek için var.';

  @override
  String get aboutSection2Title => 'Sadeliği';

  @override
  String get aboutSection2Desc =>
      'Sizi karmaşık finansal tablolar, kafa karıştırıcı menüler ve yorucu grafiklerle boğmaz. Gözü yormayan, minimalist tasarımıyla finansal takibi bir stres kaynağı olmaktan çıkarıp huzurlu bir günlük rutine dönüştürür.';

  @override
  String get aboutSection3Title => 'Farkındalığı';

  @override
  String get aboutSection3Desc =>
      'Sadece ne harcadığınızı değil, neden harcadığınızı gösterir. Satın aldığınız eşyanın gerçek bir ihtiyaç mı yoksa anlık bir heves mi olduğunu anlamanızı sağlayarak tüketim psikolojinizi aydınlatır.';

  @override
  String get aboutSection4Title => 'Pratikliği';

  @override
  String get aboutSection4Desc =>
      'Günlük hayatın hızına mükemmel ayak uydurur. Uzun ve sıkıcı formlar doldurmadan saniyeler içinde harcama girebilir, bütçenizi tek dokunuşla güncelleyebilir ve finansal durumunuzu bir bakışta özetleyebilirsiniz.';

  @override
  String get aboutSection5Title => 'Kişiselleştirilebilirliği';

  @override
  String get aboutSection5Desc =>
      'Herkesin yaşam tarzı ve finansal yolculuğu kendine özgüdür. Pretio\'yu kendi harcama kategorilerinizi oluşturarak, size özel hedefler belirleyerek ve hızlı işlem tutarlarınızı ayarlayarak tamamen kendi alışkanlıklarınıza göre şekillendirebilirsiniz.';

  @override
  String get aboutFooterNote =>
      'Bu uygulama, tüketim çılgınlığına karşı kendi iradenizi korumanız için bağımsız bir grup geliştirici tarafından hayata geçirildi.';

  @override
  String get developersTitle => 'Geliştiricilerimiz';

  @override
  String get averageSoFar => 'Bugüne kadar ortalama';

  @override
  String get all => 'Tümü';

  @override
  String get favorites => 'Favoriler';

  @override
  String get currentNetBalance => 'Net Güncel Bakiye';

  @override
  String get makeTransaction => 'İşlem Yap';

  @override
  String get expense => 'Gider';

  @override
  String get income => 'Gelir';

  @override
  String insightProjectionGood(String percent) {
    return 'Bu hızla harcarsanız ay sonunda hedefinizden %$percent daha fazla birikim yapacaksınız.';
  }

  @override
  String insightProjectionBad(String percent) {
    return 'Bu hızla harcarsanız ay sonunda hedefinizden %$percent daha az birikim yapacaksınız.';
  }

  @override
  String insightCategoryAlert(String category) {
    return 'Bu ay en çok $category kategorisinde harcama yaptınız.';
  }

  @override
  String insightStreak(int days) {
    return 'Harika! $days gündür hiç harcama yapmadınız.';
  }
}

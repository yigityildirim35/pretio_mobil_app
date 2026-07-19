import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// ---------------------------------------------------------------------------
// Pretio — Notification IDs
// ---------------------------------------------------------------------------
// 1  → Morning 09:30
// 2  → Noon 12:00
// 3  → Afternoon 16:00
// 4  → Night 22:00
// 5  → Daily reminder (random window)
// 10 → Streak milestone
// 11 → No data warning
// 12 → No-spend casual
// 13 → No-spend prompt (tap to record)
// 14 → Daily limit kept
// ---------------------------------------------------------------------------

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;
  Completer<void>? _initCompleter;

  // -------------------------------------------------------------------------
  // Message Pools
  // -------------------------------------------------------------------------

  static const List<String> _morningTitles = [
    '☀️ Günaydıııın!',
    '☀️ Yeni Bir Gün',
    '☀️ Günaydın',
    '🌅 Uyanma Vakti!',
    '☀️ Bilinçli Bir Gün!',
  ];

  static const List<String> _morningBodies = [
    'Yeni bir gün, taze bir limit! Bugün iradeni korumaya hazır mısın?',
    'Bugün yapacağın her harcama, hedefine bir adım ya da sapma olacak. Seçim senin.',
    'Satın alırken sadece etiketine değil, sana ne hissettireceğine de bak.',
    'Gerçek günlük limitin seni bekliyor. Uyanma ve kontrolü ele alma vakti!',
    '"Acaba alsam mı?" dediğin anlarda buradayım. Bilinçli bir gün geçirelim!',
  ];

  static const List<String> _noonTitles = [
    '📊 Günün Yarısı Bitti!',
    '🛒 Öğle Molası',
    '⏱️ Zaman Maliyeti',
    '🍕 Öğle Keyfi',
    '☕ Kısa Mola',
  ];

  static const List<String> _noonBodies = [
    'Günlük limitinin neresindesin? Kısa bir durum değerlendirmesi için Pretio\'ya bak.',
    'Sepeti onaylamadan önce kendine dürüstçe sor: "Bu gerçekten bir ihtiyaç mı?"',
    'Dışarıdaki o yemek sana kaç "ömür saatine" mal oldu? Harcamanı gir ve gör.',
    'Öğle yemeği güzeldi değil mi? Hesabı öderken Pretio\'yu hatırladın mı?',
    'Kısa bir moladayken bugünkü harcamalarını girip zihnini rahatlatmaya ne dersin?',
  ];

  static const List<String> _afternoonTitles = [
    '😮‍💨 Günün Yorgunluğu',
    '🏠 Eve Dönüş Yolu',
    '🎯 Hedefe Az Kaldı!',
    '👀 Seni Görüyorum!',
    '💪 Diren!',
    '🌬️ Derin Bir Nefes',
  ];

  static const List<String> _afternoonBodies = [
    'Stresini alışverişle değil, dinlenerek at. Cüzdanını ve iradeni koru!',
    'Vitrinlere ve anlık dürtülere karşı irade kalkanlarını açık tutmaya devam et.',
    'Akşama kadar planına sadık kalırsan bütçe dengen bozulmayacak. Az kaldı!',
    'Alışveriş sitelerine kaymasın o gözler! Seni görüyorum 👀 Cüzdanı yavaşça bırak...',
    'Yorgunluk iradenin düşmanıdır. Geçici bir harcama, yarınki büyük pişmanlığın olmasın.',
    'Rahatlamak için para harcamaya ihtiyacın yok. Derin bir nefes al, hedefini düşün.',
  ];

  static const List<String> _nightTitles = [
    '🌙 Dürüst Olma Vakti',
    '🔄 Günü Sıfırlıyoruz',
    '🌙 İyi Gecelerrr!',
    '😅 Cüzdan Rahatladı mı?',
    '📋 Hesaplaşma Vakti',
    '🗺️ Günün Haritası',
  ];

  static const List<String> _nightBodies = [
    'Bugün cüzdanından çıkanlar ihtiyaç mıydı, yoksa heves mi? Gel beraber bakalım.',
    'Hedefine ne kadar yaklaştığını görmek ve bütçe dengeni kurmak için verilerini gir.',
    'Limit aşımı olmayan yeni bir güne başlamak için uykunu iyi al ve pozitif kal.',
    'Cüzdanın "Oh be, gün bitti!" diyor duyuyor musun? 😅 Hadi bugünün hesaplaşmasını yapalım.',
    'Ertelenen her hesaplaşma finansal kaostur. Harcamalarını gir ve kontrolü sağla.',
    'Bugün kaçamaklar yapmış olabilirsin. Önemli olan farkında olmak. Günün haritasını çıkar.',
  ];

  // 10 Reminder messages
  static const List<Map<String, String>> _reminders = [
    {
      'title': '💭 Bir Dakikan Var Mı?',
      'body':
          'Bir şey satın almak istiyorsan dur ve sor: "Buna gerçekten ihtiyacım var mı?"',
    },
    {
      'title': '🎯 Büyük Hedefini Hatırla',
      'body':
          'Alışveriş krizin mi geldi? Pretio\'yu aç ve asıl büyük hedefini hatırla.',
    },
    {
      'title': '⌛ Paranın Gerçek Maliyeti',
      'body': 'Paran senin yaşam sürendir. Bugün zamanını neye harcadın?',
    },
    {
      'title': '⏱️ Kaç Saat Harcadın?',
      'body': 'Bugün harcadığın tutar, hayatından kaç saat götürdü?',
    },
    {
      'title': '🌟 Harika Gidiyorsun!',
      'body':
          'Bugün limitinde kalarak aylık birikim hedefini korudun. Devam et!',
    },
    {
      'title': '⚠️ Dikkatli Ol',
      'body':
          'Stresli veya üzgünken alışveriş yapmak cüzdanın için en tehlikelisidir.',
    },
    {
      'title': '💡 Küçük Bir Hatırlatma',
      'body': 'Her harcamanın bir değeri var, bunun bilincinde harcama yap.',
    },
    {
      'title': '🏦 Tasarruf Aklında mı?',
      'body':
          'Bugün harcamadığın her kuruş, yarınki özgürlüğüne bir adım daha yaklaşmanı sağlar.',
    },
    {
      'title': '📱 Pretio Seni Bekliyor',
      'body':
          'Son harcamalarını girdin mi? Verilerini güncel tut, serini koru!',
    },
    {
      'title': '🧠 Bilinçli Harcama',
      'body':
          '"İhtiyacım var" ile "İstiyorum" arasındaki fark, cüzdanında büyük fark yaratır.',
    },
    {
      'title': '🛒 O Sepet Hâlâ Orada!',
      'body':
          'Sepette unuttuğun o ürün var ya... Bırak orada kalsın, orada daha güzel duruyor! 🛒',
    },
    {
      'title': '💪 İradeni Koru',
      'body':
          'Paranı yönetmezsen dürtülerin seni yönetir. İradeni kimseye teslim etme.',
    },
    {
      'title': '💙 Sen Güçlüsün',
      'body':
          'Moral bozukken "bir şeyler almak" isteriz ama sen o geçici hislerden daha güçlüsün.',
    },
  ];

  // -------------------------------------------------------------------------
  // Channel / Details helpers
  // -------------------------------------------------------------------------

  static const String _channelId = 'pretio_main';
  static const String _channelName = 'Pretio Bildirimleri';
  static const String _channelDesc = 'Günlük harcama takip bildirimleri';

  NotificationDetails get _details => NotificationDetails(
    android: AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: true,
      playSound: true,
    ),
  );

  // -------------------------------------------------------------------------
  // Initialization
  // -------------------------------------------------------------------------

  Future<void> initialize() async {
    if (_isInitialized) return;
    if (_initCompleter != null) return _initCompleter!.future;

    _initCompleter = Completer<void>();

    tz.initializeTimeZones();
    try {
      tz.setLocalLocation(tz.getLocation('Europe/Istanbul'));
    } catch (_) {
      try {
        tz.setLocalLocation(tz.getLocation('UTC'));
      } catch (_) {}
    }

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _plugin.initialize(settings: initSettings);

    // Request Android 13+ posting permission
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      await android.requestNotificationsPermission();
      await android.requestExactAlarmsPermission();
    }

    // Request iOS Permission
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (ios != null) {
      await ios.requestPermissions(alert: true, badge: true, sound: true);
    }

    _isInitialized = true;
    _initCompleter?.complete();
    debugPrint('[NotificationService] Initialized.');
  }

  /// Helper to wait until service is ready
  Future<void> ensureInitialized() async {
    if (_isInitialized) return;
    if (_initCompleter != null) {
      return _initCompleter!.future;
    }
    // If not even started, start it
    return initialize();
  }

  // -------------------------------------------------------------------------
  // Helpers
  // -------------------------------------------------------------------------

  /// Returns the next occurrence of [hour]:[minute] in local timezone.
  tz.TZDateTime _nextInstanceOf(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(now.add(const Duration(seconds: 5)))) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  /// Deterministic index (rotates daily) using YYYYMMDD as seed.
  /// Uses modulo of the smallest pool size to stay in-bounds for all pools.
  int _dailyIndex(int poolSize) {
    final now = tz.TZDateTime.now(tz.local);
    final seed = now.year * 10000 + now.month * 100 + now.day;
    return seed % poolSize;
  }

  // -------------------------------------------------------------------------
  // Schedule All Fixed Daily Notifications
  // -------------------------------------------------------------------------

  Future<void> scheduleAllDailyNotifications() async {
    // Each pool may have different sizes; pick index within the smallest relevant pool
    final morningIdx = _dailyIndex(_morningTitles.length);
    final noonIdx = _dailyIndex(_noonTitles.length);
    final afternoonIdx = _dailyIndex(_afternoonTitles.length);
    final nightIdx = _dailyIndex(_nightTitles.length);

    await _scheduleDaily(
      id: 1,
      hour: 9,
      minute: 30,
      title: _morningTitles[morningIdx],
      body: _morningBodies[morningIdx],
    );
    await _scheduleDaily(
      id: 2,
      hour: 12,
      minute: 0,
      title: _noonTitles[noonIdx],
      body: _noonBodies[noonIdx],
    );
    await _scheduleDaily(
      id: 3,
      hour: 16,
      minute: 0,
      title: _afternoonTitles[afternoonIdx],
      body: _afternoonBodies[afternoonIdx],
    );
    await _scheduleDaily(
      id: 4,
      hour: 22,
      minute: 0,
      title: _nightTitles[nightIdx],
      body: _nightBodies[nightIdx],
    );

    debugPrint('[NotificationService] Fixed daily notifications scheduled.');
  }

  Future<void> _scheduleDaily({
    required int id,
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    try {
      await _plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: _nextInstanceOf(hour, minute),
        notificationDetails: _details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      debugPrint('[NotificationService] Failed to schedule daily ID $id: $e');
    }
  }

  // -------------------------------------------------------------------------
  // Daily Reminder — Random Window (13-15 OR 17-21), 1 per day
  // -------------------------------------------------------------------------

  Future<void> scheduleDailyReminderNotification() async {
    final rng = Random();
    // Fair coin: true = 13:00-14:59 window, false = 17:00-20:59 window
    int hour;
    int minute;
    if (rng.nextBool()) {
      hour = 13 + rng.nextInt(2); // 13 or 14
      minute = rng.nextInt(60);
    } else {
      hour = 17 + rng.nextInt(4); // 17, 18, 19, or 20
      minute = rng.nextInt(60);
    }

    final reminderIdx = rng.nextInt(_reminders.length);
    final reminder = _reminders[reminderIdx];

    try {
      await _plugin.zonedSchedule(
        id: 5,
        title: reminder['title']!,
        body: reminder['body']!,
        scheduledDate: _nextInstanceOf(hour, minute),
        notificationDetails: _details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      debugPrint(
        '[NotificationService] Daily reminder scheduled at $hour:${minute.toString().padLeft(2, '0')} (msg #$reminderIdx).',
      );
    } catch (e) {
      debugPrint('[NotificationService] Failed to schedule daily reminder: $e');
    }
  }

  // -------------------------------------------------------------------------
  // Cancel All
  // -------------------------------------------------------------------------

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
    debugPrint('[NotificationService] All notifications cancelled.');
  }

  // -------------------------------------------------------------------------
  // Conditional (Immediate) Notifications
  // -------------------------------------------------------------------------

  Future<void> showStreakMilestone(int streakDays) async {
    await _plugin.show(
      id: 10,
      title: '🎉 $streakDays Günlük Seri!',
      body:
          'Limitinin altında harcama yapmadığın $streakDays. gün!!! Tebrikleeeer!!',
      notificationDetails: _details,
    );
    debugPrint('[NotificationService] Streak milestone: $streakDays days.');
  }

  Future<void> showNoDataWarning() async {
    await _plugin.show(
      id: 11,
      title: '⚠️ Veri Girilmedi!',
      body: 'Dikkat, bu gün hiç veri girmedin! Serini kaybedebilirsin!',
      notificationDetails: _details,
    );
  }

  Future<void> showNoSpendCasual() async {
    await _plugin.show(
      id: 12,
      title: '🏆 Sıfır Harcama Günü?',
      body: 'Neee gerçekten hiç para harcamadın mı? İnanamıyoruuum! WOOOW!',
      notificationDetails: _details,
    );
  }

  Future<void> showNoSpendPrompt() async {
    await _plugin.show(
      id: 13,
      title: '🏆 Harika Bir Gün!',
      body:
          'Bugün hiç para harcamadın mı? Serini uzatmak için uygulamaya tıkla!',
      notificationDetails: _details,
    );
  }

  Future<void> scheduleDailyLimitKept() async {
    try {
      await _plugin.zonedSchedule(
        id: 14,
        title: '✅ Limit Korundu!',
        body:
            'Harika gidiyorsun! Bugün limitinde kalarak aylık birikim hedefini korudun.',
        scheduledDate: _nextInstanceOf(21, 0), // 21:00
        notificationDetails: _details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      debugPrint(
        '[NotificationService] Failed to schedule limit kept notif: $e',
      );
    }
  }

  Future<void> cancelDailyLimitKept() async {
    await _plugin.cancel(id: 14);
  }

  Future<void> scheduleNoSpendPrompt() async {
    try {
      await _plugin.zonedSchedule(
        id: 13,
        title: '🏆 Harika Bir Gün!',
        body:
            'Bugün hiç para harcamadın mı? Serini uzatmak ve zaferini kaydetmek için uygulamaya tıkla!',
        scheduledDate: _nextInstanceOf(23, 30), // 23:30
        notificationDetails: _details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      debugPrint(
        '[NotificationService] Failed to schedule no spend prompt: $e',
      );
    }
  }

  Future<void> cancelNoSpendPrompt() async {
    await _plugin.cancel(id: 13);
  }

  Future<void> showDailyLimitKept() async {
    await _plugin.show(
      id: 14,
      title: '✅ Limit Korundu!',
      body:
          'Harika gidiyorsun! Bugün limitinde kalarak aylık birikim hedefini korudun.',
      notificationDetails: _details,
    );
  }

  // -------------------------------------------------------------------------
  // Milestone check helper
  // -------------------------------------------------------------------------

  static const List<int> _milestoneDays = [
    7,
    14,
    30,
    60,
    100,
    150,
    200,
    300,
    365,
  ];

  bool isMilestone(int streakDays) => _milestoneDays.contains(streakDays);

  // -------------------------------------------------------------------------
  // Test Notif
  // -------------------------------------------------------------------------

  Future<void> testNotification() async {
    final now = tz.TZDateTime.now(tz.local);
    await _plugin.zonedSchedule(
      id: 99,
      title: '🚀 Test Başarılı!',
      body: 'Zamanlanmış bildirim sistemin tıkır tıkır çalışıyor.',
      scheduledDate: now.add(const Duration(seconds: 15)), // 15 Saniye sonra
      notificationDetails: _details,
      androidScheduleMode:
          AndroidScheduleMode.exactAllowWhileIdle, // Test için exact
    );
    debugPrint('15 saniye sonrası için test bildirimi kuruldu.');
  }
}

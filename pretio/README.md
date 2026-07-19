# Pretio - Değerin Mantığı

Pretio, harcamalarınızın sadece parasal tutarını değil, **"Zaman Maliyeti" (Time Cost)** prensibini temel alarak hayatınızdan giden süreyi (çalışma saatlerinizi) hesaplayan premium ve modern bir finansal takip uygulamasıdır.

Uygulamanın sloganı: **"Zamanının gerçek değerini hesapla."**

---

## 🚀 Öne Çıkan Özellikler

*   **Zaman Maliyeti (Time Cost) Hesaplama:** Saatlik kazancınızı temel alarak yaptığınız harcamaların ve aboneliklerin size gerçekte kaç çalışma saatine mâl olduğunu görebilirsiniz.
*   **Abonelik Yönetimi:** Düzenli ödemelerinizi takip edin, bildirimlerle ödeme günlerini kaçırmayın ve aylık/yıllık bütçenize olan etkisini analiz edin.
*   **Dinamik Bütçe ve Hedefler:** Finansal hedeflerinizi belirleyin ve bütçe halkası (Budget Ring) ile harcama durumunuzu görsel olarak izleyin.
*   **Gelişmiş Analitik ve Grafikler:** `fl_chart` ile desteklenen interaktif harcama analizleri, kategorisel dağılımlar ve dönemsel grafikler.
*   **Duygu ve İhtiyaç Analizi:** Her harcama için duygu durumu (öfke, mutluluk, stres vb.) ve gereksinim düzeyini (ihtiyaç, lüks vb.) kaydederek harcama alışkanlıklarınızın psikolojik analizini yapın.
*   **Rozet Galerisi (Gamification):** Finansal hedeflerinize ulaştıkça veya harcamalarınızı optimize ettikçe kilidini açabileceğiniz başarı rozetleri.
*   **Veri Dışa Aktarma:** Finansal raporlarınızı PDF formatında yazdırın ya da Excel (.xlsx) formatında dışa aktarın.
*   **Çoklu Para Birimi ve Yerelleştirme:** Farklı para birimlerini destekler ve dil seçenekleriyle esnek kullanım sunar.

---

## 🛠️ Kullanılan Teknolojiler

*   **Çatı (Framework):** [Flutter](https://flutter.dev) (iOS, Android, Web, Windows vb. çoklu platform desteği)
*   **Durum Yönetimi (State Management):** `provider` ve `flutter_riverpod`
*   **Yerel Depolama (Local Storage):** `shared_preferences`
*   **Grafikler:** `fl_chart`
*   **Bildirimler:** `flutter_local_notifications` & `timezone`
*   **Belge Üretimi:** `pdf`, `printing`, `syncfusion_flutter_xlsio`
*   **Ağ İletişimi:** `dio` & `http`

---

## 📂 Proje Klasör Yapısı

```text
lib/
├── core/               # Hata yönetimi ve ağ bağlantı altyapısı
├── data/               # Veri kaynakları ve depolama servisleri
├── domain/             # İş mantığı kuralları (Use cases vb.)
├── features/           # Spesifik özellik modülleri
├── l10n/               # Çoklu dil (Localization) dosyaları
├── models/             # Veri modelleri (Transaction, Category vb.)
├── providers/          # Global state (durum) yönetimi sağlayıcıları
├── screens/            # Kullanıcı arayüzü sayfaları (Dashboard, Settings, Analytics vb.)
├── services/           # Servisler (Bildirim, Para Birimi, Excel/PDF Aktarımı)
├── utils/              # Yardımcı araçlar ve sabitler
├── widgets/            # Yeniden kullanılabilir arayüz bileşenleri
└── main.dart           # Uygulamanın başlangıç noktası
```

---

## ⚙️ Kurulum ve Çalıştırma

Projeyi yerel bilgisayarınızda çalıştırmak için aşağıdaki adımları izleyin:

### 1. Gereksinimler
*   Bilgisayarınızda **Flutter SDK** yüklü olmalıdır. (Kurulum için [Flutter Get Started](https://flutter.dev/docs/get-started/install) rehberini inceleyebilirsiniz.)
*   Bir kod editörü (VS Code veya Android Studio).

### 2. Projeyi Çalıştırma Adımları

1.  Uygulamanın ana klasörüne gidin:
    ```bash
    cd c:/Users/yyild/Downloads/pretio/pretio
    ```

2.  Bağımlılıkları (paketleri) indirin:
    ```bash
    flutter pub get
    ```

3.  Uygulamayı bir emülatörde, simülatörde veya bağlı fiziksel cihazda çalıştırın:
    ```bash
    flutter run
    ```

---

## 📝 Lisans ve Katkıda Bulunma

Bu proje özel bir şahsi finans projesi olarak geliştirilmektedir. Katkıda bulunmak isterseniz lütfen bir Pull Request (PR) açın veya geliştirmek istediğiniz özelliği bildirin.

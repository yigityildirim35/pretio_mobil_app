# 💸 Pretio – Değerin Mantığı

Pretio, harcamalarınızın yalnızca parasal tutarını değil, **"Zaman Maliyeti (Time Cost)"** yaklaşımını temel alarak size gerçekte kaç saat veya dakika çalışmaya mal olduğunu hesaplayan modern ve kullanıcı odaklı bir kişisel finans yönetimi uygulamasıdır.

**Slogan:** *"Zamanının gerçek değerini hesapla."*
> 📱 Uygulamanın ekran görüntülerini README'nin sonunda inceleyebilirsiniz.
---

# 🚀 Öne Çıkan Özellikler

### ⏳ Zaman Maliyeti (Time Cost)

Pretio'nun en dikkat çekici özelliği, yapılan harcamaları yalnızca para olarak değil **çalışma süresi** olarak da değerlendirmesidir.

Kullanıcı;

- Aylık maaşını
- Haftalık çalışma saatini

girerek;

- Saatlik kazancını,
- Dakikalık kazancını,

hesaplayabilir.

Ardından yapılan her harcama için;

> **"Bu harcama için kaç dakika/saat çalışmanız gerekiyor?"**

sorusunun cevabı otomatik olarak hesaplanır.

---

### 🎯 Akıllı Hedef Takibi

Kullanıcılar finansal hedeflerini belirleyebilir ve ilerlemelerini anlık olarak takip edebilir.

- Hedef oluşturma
- Hedef ilerleme yüzdesi
- Kalan hedef tutarı
- Günlük harcama limiti
- Tahmini aylık birikim
- Budget Ring (Bütçe Halkası) ile görsel ilerleme takibi

---

### 💰 Harcama Takibi

Harcamalar ayrıntılı bilgilerle kaydedilebilir.

- Harcama adı
- Tutar
- Kategori
- Tarih
- Ruh hali
- İstek / İhtiyaç etiketi
- Düzenleme ve silme işlemleri

---

### 📊 Gelişmiş Harcama Analizi

Harcama alışkanlıklarını analiz ederek kullanıcıya finansal farkındalık kazandırır.

- Günlük ortalama harcama
- Aylık analizler
- Kategori bazlı harcamalar
- Günlük limit karşılaştırması
- Hedef performansı
- İnteraktif grafikler (`fl_chart`)

---

### 📅 Takvim Görünümü

Takvim ekranı sayesinde kullanıcı günlük bütçe performansını kolayca takip edebilir.

- Gün bazlı harcamalar
- Aylar arasında geçiş
- Limit durumuna göre renkli gösterimler

🟢 Limit altında

🟠 Limite yakın

🔴 Limit aşıldı

---

### 💳 Abonelik Yönetimi

Düzenli ödemelerinizi tek ekrandan yönetin.

- Servis adı
- Servis ikonu
- Aylık ücret
- Ödeme tarihi
- Ödeme döngüsü
- Sonraki ödeme tarihi
- Ruh hali
- İstek / İhtiyaç etiketi
- Toplam aylık abonelik maliyeti

---

### 😊 Duygu & İhtiyaç Analizi

Her harcamaya psikolojik bilgiler eklenebilir.

- Ruh hali kaydı
- İstek / İhtiyaç sınıflandırması
- Harcama davranışlarının analizi
- Duygu bazlı tüketim alışkanlıkları

---

### 🏆 Rozet Galerisi (Gamification)

Finansal hedeflere ulaştıkça başarı rozetleri kazanılır.

Örnek rozetler:

- 🔥 Kutsal Seri
- 🛡️ Cüzdan Bekçisi
- 🧠 Duygu Dedektifi
- ⚖️ Denge Uzmanı
- 📈 Veri Kurdu

Ayrıca;

- Rozet ilerleme sistemi
- Güncel seri
- En iyi seri
- Başarı takibi

özellikleri sunulmaktadır.

---

### 👤 Profil ve İstatistikler

Profil ekranında kullanıcıya ait finansal istatistikler görüntülenebilir.

- Profil fotoğrafı
- Güncel seri
- En iyi seri
- Toplam harcama
- İstek yüzdesi
- Aktif abonelikler
- Rozet ilerleme durumu

---

### 🎨 Tema ve Kişiselleştirme

Pretio farklı görünüm seçenekleri sunar.

Desteklenen temalar;

- 🌞 Açık
- 🌙 Koyu
- 🌲 Orman Yeşili
- 🌅 Günbatımı
- 🌌 Gece Mavisi
- 🍭 Pamuk Şeker

---

### ⚙️ Ayarlar

Kullanıcı uygulamayı kendi tercihlerine göre özelleştirebilir.

- Tema değiştirme
- Dil seçimi
- Harcanan tutarı gizleme
- Ruh Hali modülünü açma/kapatma
- İstek / İhtiyaç modülünü açma/kapatma
- 3D kart efektini açma/kapatma
- Verileri sıfırlama

---

# 🛠️ Kullanılan Teknolojiler

- **Framework:** Flutter
- **Programlama Dili:** Dart
- **State Management:** Provider / Flutter Riverpod
- **Local Storage:** SharedPreferences
- **Charts:** fl_chart
- **Notifications:** flutter_local_notifications & timezone
- **Network:** Dio & HTTP
- **PDF Export:** pdf & printing
- **Excel Export:** Syncfusion Flutter XlsIO
- **UI:** Material Design 3

---

# 📂 Proje Yapısı

```text
lib/
├── core/
├── data/
├── domain/
├── features/
├── l10n/
├── models/
├── providers/
├── screens/
├── services/
├── utils/
├── widgets/
└── main.dart
```

---

# ⚙️ Kurulum

## Gereksinimler

- Flutter SDK
- Android Studio veya VS Code
- Android Emulator / Fiziksel cihaz

## Projeyi Çalıştırma

```bash
git clone https://github.com/kullaniciadi/pretio.git

cd pretio

flutter pub get

flutter run
```

---

# 💡 Projenin Amacı

Pretio'nun amacı yalnızca gelir ve giderleri kayıt altına almak değildir.

Uygulama;

- Finansal farkındalık oluşturmayı,
- Tasarruf alışkanlığı kazandırmayı,
- Harcamaların zaman karşılığını göstermeyi,
- Gereksiz harcamaları azaltmayı,
- Düzenli ödemeleri yönetmeyi,
- Oyunlaştırılmış yapıyla kullanıcı motivasyonunu artırmayı,
- Kişisel finans yönetimini daha bilinçli hâle getirmeyi amaçlamaktadır.

---

# 🌟 Öne Çıkan Özellikler

- ✅ Time Cost (Zaman Maliyeti) Hesaplama
- ✅ Akıllı Hedef Takibi
- ✅ Günlük Harcama Limiti
- ✅ Tahmini Aylık Birikim
- ✅ Budget Ring
- ✅ Harcama Analizi
- ✅ İnteraktif Grafikler
- ✅ Takvim Görünümü
- ✅ Abonelik Yönetimi
- ✅ Duygu & İhtiyaç Analizi
- ✅ Rozet ve Başarı Sistemi
- ✅ Profil ve İstatistikler
- ✅ Çoklu Tema Desteği
- ✅ Çoklu Dil Desteği
- ✅ PDF & Excel Dışa Aktarma

---

# 👨‍💻 Geliştiriciler: 
@yigityildirim35, @gizembg1m, 
Pretio, **Flutter** kullanılarak geliştirilen modern bir kişisel finans yönetimi uygulamasıdır. Proje; kullanıcı deneyimi (UX/UI), finansal farkındalık, oyunlaştırma (Gamification) ve **Time Cost** yaklaşımını bir araya getirerek kullanıcıların harcamalarını daha bilinçli yönetmelerini amaçlamaktadır.


# 📱 Ekran Görüntüleri

<img width="387" height="838" alt="image" src="https://github.com/user-attachments/assets/020d3f44-1854-43ba-8bc1-9ea76b6d0f04" />
<img width="402" height="821" alt="image" src="https://github.com/user-attachments/assets/f140210d-592f-411c-91a9-5ad478e54bbe" />
<img width="392" height="837" alt="image" src="https://github.com/user-attachments/assets/34774fb6-3cd5-4aff-a608-c4315ef25844" />
<img width="372" height="822" alt="image" src="https://github.com/user-attachments/assets/56cf6fd9-7322-4af2-a8fd-b41f6430c4d0" />
<img width="383" height="801" alt="image" src="https://github.com/user-attachments/assets/d3849628-c634-45e9-8b30-4b382d282bb5" />
<img width="400" height="827" alt="image" src="https://github.com/user-attachments/assets/269948b4-3b10-42ce-8a74-7213e1803e21" />
<img width="405" height="822" alt="image" src="https://github.com/user-attachments/assets/2fd00a6f-a05d-464c-adc2-362cdd4eede7" />
<img width="392" height="813" alt="image" src="https://github.com/user-attachments/assets/6b7a438c-6915-4d10-a40c-ac760d111a37" />
<img width="406" height="827" alt="image" src="https://github.com/user-attachments/assets/c8a8226e-f63d-40bd-b551-da4115b2e7f9" />
<img width="397" height="848" alt="image" src="https://github.com/user-attachments/assets/8eb277a5-a3fd-40ad-822c-9e3e8be4f201" />
<img width="403" height="817" alt="image" src="https://github.com/user-attachments/assets/254de5e6-02d0-455b-8784-52d1145bf59e" />
<img width="401" height="817" alt="image" src="https://github.com/user-attachments/assets/4077f387-5059-4863-9506-d38b9a738c69" />
<img width="392" height="827" alt="image" src="https://github.com/user-attachments/assets/0c099517-c306-4fdc-94f8-b655cbb95ccd" />
<img width="387" height="833" alt="image" src="https://github.com/user-attachments/assets/16c9826a-22a6-499a-b7f5-75951d37a2a9" />






---

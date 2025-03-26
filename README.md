# Ekşi Sözlük Ad Blocker

[![Geliştirici: gneral](https://img.shields.io/badge/Geli%C5%9Ftirici-gneral-81C14B.svg)](https://github.com/gneral)
[![Website: ai.zefre.net](https://img.shields.io/badge/Website-ai.zefre.net-81C14B.svg)](https://ai.zefre.net/)
[![R10: gneral](https://img.shields.io/badge/R10-gneral-81C14B.svg)](https://www.r10.net/profil/193-gneral.html)

Ekşi Sözlük için reklamsız deneyim sunan Chrome eklentisi.

## Özellikler

- Alt sabit reklamları engeller (Mobil görünümde sayfa altında yer alan sabit reklamlar)
- Kenar çubuğu reklamlarını engeller (Sayfa kenarında yer alan reklamlar)
- İçerik içi reklamları engeller (Entry'lerin arasına yerleştirilen reklamlar)
- IFrame reklamları engeller (Google Topics frame ve diğer iframe reklamları)
- Tamamen özelleştirilebilir yapılandırma
- Hızlı ve verimli performans
- Resim kullanmadan sade bir arayüz

## Nasıl Çalışır?

Bu eklenti, eksisozluk.com sitesinde gezindiğinizde sayfa içeriğini analiz eder ve reklam olarak tanımlanan öğeleri otomatik olarak kaldırır. Reklamlar DOM'dan tamamen temizlenir ve sayfa düzeni korunur.

Eklenti şu reklam türlerini tespit edip kaldırır:
- IFrame reklamlar (`goog_topics_frame` dahil)
- Alt kısımdaki sabit reklamlar (mobil sürümde)
- Yan panel reklamları
- İçerik akışı içindeki reklamlar
- Ürün reklamları ve sponsorlu içerikler

## Kurulum

### Chrome Web Mağazasından:
1. Chrome Web Mağazasından "Ekşi Sözlük Ad Blocker" eklentisini arayın
2. "Chrome'a Ekle" butonuna tıklayın
3. Eklenti otomatik olarak kurulacaktır

### Manuel Kurulum:
1. Bu depoyu ZIP olarak indirin
2. ZIP dosyasını bir klasöre çıkarın
3. Chrome'da `chrome://extensions` adresine gidin
4. "Geliştirici modu"nu etkinleştirin (sağ üst köşede)
5. "Paketlenmemiş öğe yükle" butonuna tıklayın
6. Çıkardığınız klasörü seçin
7. Eklenti tarayıcınıza yüklenecektir

## Kullanım

Kurulumdan sonra, eklenti otomatik olarak eksisozluk.com'da çalışmaya başlar. Eklenti simgesine tıklayarak ayarlarını değiştirebilirsiniz:

- Ana düğme ile eklentiyi etkinleştirebilir/devre dışı bırakabilirsiniz
- "Ayarlar" düğmesi ile detaylı yapılandırma sayfasını açabilirsiniz

Ayarlar sayfasında şu seçenekler bulunur:
- Alt Sabit Reklamları Engelle
- Kenar Çubuğu Reklamlarını Engelle
- İçerik İçi Reklamları Engelle
- IFrame Reklamları Engelle

## Teknik Detaylar

Eklenti aşağıdaki teknolojilerle geliştirilmiştir:
- JavaScript (ES6)
- Chrome Extension API
- MutationObserver API (dinamik içerik izleme)
- CSS Selectors (reklam öğelerini hedefleme)

Reklam tespiti için kullanılan yöntemler:
- Sınıf ve ID desenlerini eşleştirme
- Reklam ağlarına ait URL'leri tanıma
- Reklam konteyner yapılarını tespit etme
- Google Ad servisleri ve doubleclick.net bağlantılarını izleme

## Geliştirici Bilgileri

- Geliştirici: gneral
- E-posta: gneral@gmail.com
- Web sitesi: https://ai.zefre.net/
- R10 Profili: https://www.r10.net/profil/193-gneral.html
- GitHub: www.github.com/gneral

## Gizlilik

Bu eklenti hiçbir kullanıcı verisini toplamaz veya dış sunuculara göndermez. Tüm işlemler tarayıcınız içinde yerel olarak gerçekleştirilir. Kullanıcı tercihleri sadece yerel tarayıcı deposunda saklanır.

## Lisans

Bu proje MIT lisansı altında açık kaynaklıdır. Kod tabanını istediğiniz gibi kullanabilir, değiştirebilir ve dağıtabilirsiniz.

---

&copy; 2025 gneral. Tüm hakları saklıdır.
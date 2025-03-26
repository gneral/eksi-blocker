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

## Kurulum

### Windows'ta Kurulum
1. Proje dosyalarını bilgisayarınıza indirin
2. `kurulum.bat` dosyasını çalıştırın
3. Script otomatik olarak gereken tüm dosyaları oluşturacak ve temel ikonları hazırlayacaktır
4. Oluşturulan klasörü ya da ZIP dosyasını Chrome'a yükleyin

### Chrome'a Yükleme
1. Chrome tarayıcınızda `chrome://extensions` adresine gidin
2. Sağ üst köşedeki "Geliştirici modu"nu etkinleştirin
3. "Paketlenmemiş öğe yükle" butonuna tıklayın
4. Projenizin bulunduğu klasörü seçin ya da oluşturulan ZIP dosyasını çıkardığınız klasörü gösterin
5. Eklenti tarayıcınıza yüklenecektir

## Nasıl Çalışır?

Bu eklenti, eksisozluk.com sitesinde gezindiğinizde sayfa içeriğini analiz eder ve reklam olarak tanımlanan öğeleri otomatik olarak kaldırır. Reklamlar DOM'dan tamamen temizlenir ve sayfa düzeni korunur.

Eklenti şu reklam türlerini tespit edip kaldırır:
- IFrame reklamlar (`goog_topics_frame` dahil)
- Alt kısımdaki sabit reklamlar (mobil sürümde)
- Yan panel reklamları
- İçerik akışı içindeki reklamlar
- Ürün reklamları ve sponsorlu içerikler

## Kullanım

Kurulumdan sonra, eklenti otomatik olarak eksisozluk.com'da çalışmaya başlar. Eklenti simgesine tıklayarak ayarlarını değiştirebilirsiniz:

- Ana düğme ile eklentiyi etkinleştirebilir/devre dışı bırakabilirsiniz
- "Ayarlar" düğmesi ile detaylı yapılandırma sayfasını açabilirsiniz

Ayarlar sayfasında şu seçenekler bulunur:
- Alt Sabit Reklamları Engelle
- Kenar Çubuğu Reklamlarını Engelle
- İçerik İçi Reklamları Engelle
- IFrame Reklamları Engelle

## Proje Dosyaları

- `manifest.json`: Eklentinin tanımlayıcı dosyası
- `content.js`: Reklam engelleme algoritması
- `background.js`: Arka plan işlemleri için hizmet çalıştırıcı
- `popup.html/js`: Eklenti popup arayüzü
- `options.html/js`: Ayarlar sayfası
- `kurulum.bat`: Windows için kurulum scripti
- `icons/`: Eklenti ikonları

## Geliştirici Notları

- Eklenti, MutationObserver API kullanarak dinamik olarak yüklenen reklamları da tespit eder
- CSS seçiciler ve DOM manipülasyonu ile reklamlar sayfa yüklenmeden önce engellenir
- Çerezlere veya site verilerine müdahale edilmez, sadece reklam içerikleri kaldırılır

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
#!/bin/bash
# File: setup.sh
# Path: /home/main/public_html/ai.zefre.net/eksi-blocker/setup.sh
# Developer: gneral <gneral@gmail.com>
# Website: https://ai.zefre.net/
# R10 Profile: https://www.r10.net/profil/193-gneral.html
# GitHub: www.github.com/gneral

# Renkli çıktı için
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Ekşi Sözlük Ad Blocker Kurulum Scripti${NC}"
echo "=============================="

# Temel bilgileri tanımla
PROJECT_NAME="eksi-blocker"
PROJECT_DIR="/home/main/public_html/ai.zefre.net/$PROJECT_NAME"
PROJECT_ZIP="$PROJECT_NAME.zip"
DOWNLOAD_URL="https://ai.zefre.net/$PROJECT_NAME/$PROJECT_ZIP"
ICON_SIZES=(16 48 128)

# Kurulum dizinini oluştur
mkdir -p "$PROJECT_DIR"
if [ ! -d "$PROJECT_DIR" ]; then
    echo -e "${RED}Proje dizini oluşturulamadı: $PROJECT_DIR${NC}"
    exit 1
fi

echo -e "${GREEN}Proje dizini oluşturuldu: $PROJECT_DIR${NC}"

# İkon dizinini oluştur
mkdir -p "$PROJECT_DIR/icons"
if [ ! -d "$PROJECT_DIR/icons" ]; then
    echo -e "${RED}İkon dizini oluşturulamadı!${NC}"
    exit 1
fi

echo -e "${GREEN}İkon dizini oluşturuldu.${NC}"

# Basit ikonlar oluştur (SVG yerine küçük PNG dosyaları)
for size in "${ICON_SIZES[@]}"; do
    # Linux'ta çalışan ImageMagick komutuyla basit ikonlar oluştur
    convert -size ${size}x${size} xc:none -fill "#81C14B" -draw "circle $(($size/2)),$(($size/2)) $(($size/2)),1" "$PROJECT_DIR/icons/icon$size.png"
    if [ $? -ne 0 ]; then
        echo -e "${YELLOW}İkon oluşturulamadı: icon$size.png - Varsayılan simge dosyaları kullanılacak.${NC}"
        
        # Varsayılan simge olarak boş bir PNG oluştur
        (
            echo -e "\x89PNG\r\n\x1a\n\x00\x00\x00\rIHDR\x00\x00\x00$size\x00\x00\x00$size\x08\x06\x00\x00\x00\x8e\x99\x1a\x1a\x00\x00\x00\x06bKGD\x00\xff\x00\xff\x00\xff\xa0\xbd\xa7\x93\x00\x00\x00\x09pHYs\x00\x00\x0b\x13\x00\x00\x0b\x13\x01\x00\x9a\x9c\x18\x00\x00\x00\x07tIME\x07\xe5\x05\x07\x00\x0c'\x95\x00\x00\x00\x1diTXtComment\x00\x00\x00\x00\x00Created with GIMPd.e\x07\x00\x00\x00zIDAT8\xcb\xed\xd5\xb1\n\x80 \x14\x06\xe0\xa8\xa5!\x8a\x86\xc8\x86\xc8\x86z\xa4\xb6\x16_\xba\xa1\x87\x11\x11\x82\x9a\x04\xf1\x10\xe7\xdc\x0e\x1e\x84\xe3\xffw\xe0\xce\x19\xe0\xf0\x93\xc1\xef\xf9\x97\xcd&\xa2\x9a\x88j\xaa\x8a\xbcN\x03\x8f\xcc,\xe7\x1c\x00\xcc\xcc\xe7\xa9N)\xd5\xbc\xef\xfb~\x96RZ\xad\xd5\x94\xd2\xb9+d\x8f\xeas\x9cR\xcazO}\x98\xa2\xaa\xb5\x8a\xefl\xe0\xec\"\xa2\n\x00\x0f\xb3\xf2;\x16\xa8\x990\xb8\x00\x00\x00\x00IEND\xaeB`\x82" > "$PROJECT_DIR/icons/icon$size.png"
        )
    fi
    echo -e "${GREEN}İkon oluşturuldu: icon$size.png${NC}"
done

# Manifest dosyasını oluştur
cat > "$PROJECT_DIR/manifest.json" << EOF
{
  "manifest_version": 3,
  "name": "Ekşi Sözlük Ad Blocker",
  "version": "1.0.0",
  "description": "Ekşi Sözlük için reklam engelleme eklentisi",
  "author": "gneral",
  "icons": {
    "16": "icons/icon16.png",
    "48": "icons/icon48.png",
    "128": "icons/icon128.png"
  },
  "action": {
    "default_popup": "popup.html",
    "default_title": "Ekşi Sözlük Ad Blocker"
  },
  "permissions": [
    "storage"
  ],
  "host_permissions": [
    "*://eksisozluk.com/*",
    "*://*.eksisozluk.com/*"
  ],
  "content_scripts": [
    {
      "matches": ["*://eksisozluk.com/*", "*://*.eksisozluk.com/*"],
      "js": ["content.js"],
      "run_at": "document_start"
    }
  ],
  "background": {
    "service_worker": "background.js"
  },
  "options_ui": {
    "page": "options.html",
    "open_in_tab": false
  }
}
EOF

echo -e "${GREEN}manifest.json dosyası oluşturuldu.${NC}"

# content.js dosyasını oluştur
cat > "$PROJECT_DIR/content.js" << EOF
// File: content.js
// Path: /home/main/public_html/ai.zefre.net/eksi-blocker/content.js
// Developer: gneral <gneral@gmail.com>
// Website: https://ai.zefre.net/
// R10 Profile: https://www.r10.net/profil/193-gneral.html
// GitHub: www.github.com/gneral

// Initialize default settings
let settings = {
  blockBottomStickyAds: true,
  blockSidebarAds: true,
  blockInlineAds: true,
  blockIframes: true
};

// Load user settings
chrome.storage.sync.get(settings, function(items) {
  settings = items;
  
  // Apply ad blocking immediately
  removeAds();
  
  // Create mutation observer to continually remove ads as they appear
  setupAdBlocker();
});

// Main function to remove ads based on settings
function removeAds() {
  // Block iframes (including Google Topics frame)
  if (settings.blockIframes) {
    const iframes = document.querySelectorAll('iframe');
    iframes.forEach(iframe => {
      if (iframe.src.includes('doubleclick.net') || 
          iframe.src.includes('googlesyndication.com') ||
          iframe.name === 'goog_topics_frame') {
        iframe.remove();
      }
    });
  }

  // Block sticky bottom ads on mobile
  if (settings.blockBottomStickyAds) {
    const bottomAds = document.querySelectorAll('ins[id^="gpt_unit_"][style*="bottom: 0px"][style*="position: fixed"]');
    bottomAds.forEach(ad => ad.remove());
    
    // Also remove by container ID
    const adContainers = document.querySelectorAll('div[id^="google_ads_iframe_"][id$="__container__"]');
    adContainers.forEach(container => {
      const parent = container.parentElement;
      if (parent && parent.tagName === 'INS') {
        parent.remove();
      } else {
        container.remove();
      }
    });
  }

  // Block sidebar ads
  if (settings.blockSidebarAds) {
    // Find elements with class containing "column-container" or "logo-box"
    const sidebarAds = document.querySelectorAll('div[class*="column-container"], div[class*="logo-box"]');
    sidebarAds.forEach(ad => {
      // Check if it's an ad container by looking for nested elements
      if (ad.querySelector('a[href*="googleadservices.com"]') || 
          ad.querySelector('div[class*="product-container"]') ||
          ad.querySelector('div[class*="logo"]')) {
        ad.remove();
      }
    });
    
    // Target specific ad class patterns
    document.querySelectorAll('div[class*="cropped-image-intermedia-box"]').forEach(ad => ad.remove());
  }

  // Block inline ads (in content)
  if (settings.blockInlineAds) {
    // Target "hotspot" class ads
    document.querySelectorAll('div[class*="hotspot"]').forEach(ad => ad.remove());
    
    // Target common ad container classes
    document.querySelectorAll('div[class*="x-layout"], div[id^="div-gpt-ad"]').forEach(ad => ad.remove());
    
    // Target class patterns unique to ads
    document.querySelectorAll('div[class^="ns-"]').forEach(ad => {
      // Check if it's an ad container
      if (ad.querySelector('a[href*="googleadservices"]') || 
          ad.querySelector('div[class*="logo"]') ||
          ad.querySelector('div[class*="product"]')) {
        ad.remove();
      }
    });
  }
}

// Set up mutation observer to continuously block ads as they appear
function setupAdBlocker() {
  const observer = new MutationObserver(mutations => {
    let shouldRemoveAds = false;
    
    for (const mutation of mutations) {
      if (mutation.type === 'childList' && mutation.addedNodes.length > 0) {
        shouldRemoveAds = true;
        break;
      }
    }
    
    if (shouldRemoveAds) {
      removeAds();
    }
  });
  
  // Start observing the entire document for changes
  observer.observe(document.documentElement, {
    childList: true,
    subtree: true
  });
}

// Apply custom CSS to hide ad spaces
function injectStyles() {
  const style = document.createElement('style');
  style.textContent = \`
    /* Hide common ad containers */
    div[class*="GoogleActiveViewElement"],
    div[class*="ad-container"],
    div[class*="adbox"],
    div[id^="div-gpt-ad"],
    ins[id^="gpt_unit_"],
    iframe[name="goog_topics_frame"],
    div.o43328.el.hotspot,
    div[class*="ns-"][data-google-av-adk],
    div[class*="logo-box"],
    div[class*="product-container"] {
      display: none !important;
    }
    
    /* Fix layout after removing ads */
    body {
      overflow: auto !important;
    }
    
    /* Ensure no space is reserved for removed ads */
    div[style*="bottom: 0px"][style*="position: fixed"] {
      display: none !important;
    }
  \`;
  document.head.appendChild(style);
}

// Inject CSS as early as possible
injectStyles();

// Run again when DOM is fully loaded
document.addEventListener('DOMContentLoaded', function() {
  removeAds();
  injectStyles();
});

// Also run when page is fully loaded with resources
window.addEventListener('load', function() {
  removeAds();
});

// Run periodically to catch any delayed ads
setInterval(removeAds, 2000);
EOF

echo -e "${GREEN}content.js dosyası oluşturuldu.${NC}"

# background.js dosyasını oluştur
cat > "$PROJECT_DIR/background.js" << EOF
// File: background.js
// Path: /home/main/public_html/ai.zefre.net/eksi-blocker/background.js
// Developer: gneral <gneral@gmail.com>
// Website: https://ai.zefre.net/
// R10 Profile: https://www.r10.net/profil/193-gneral.html
// GitHub: www.github.com/gneral

// Initialize default settings if not already set
chrome.runtime.onInstalled.addListener(function() {
  chrome.storage.sync.get({
    blockBottomStickyAds: true,
    blockSidebarAds: true,
    blockInlineAds: true,
    blockIframes: true,
    enabled: true
  }, function(items) {
    // Save default settings if they don't exist
    chrome.storage.sync.set(items);
  });
});

// Listen for messages from popup or options page
chrome.runtime.onMessage.addListener(function(request, sender, sendResponse) {
  if (request.action === "getStatus") {
    chrome.storage.sync.get({
      enabled: true
    }, function(items) {
      sendResponse({enabled: items.enabled});
    });
    return true; // Important: indicates async response
  }
  
  if (request.action === "toggleEnabled") {
    chrome.storage.sync.set({
      enabled: request.enabled
    }, function() {
      // Reload active eksisozluk tabs
      chrome.tabs.query({
        url: ["*://eksisozluk.com/*", "*://*.eksisozluk.com/*"]
      }, function(tabs) {
        tabs.forEach(function(tab) {
          chrome.tabs.reload(tab.id);
        });
      });
      
      sendResponse({status: "success"});
    });
    return true; // Important: indicates async response
  }
  
  if (request.action === "updateSettings") {
    chrome.storage.sync.set(request.settings, function() {
      // Reload active eksisozluk tabs
      chrome.tabs.query({
        url: ["*://eksisozluk.com/*", "*://*.eksisozluk.com/*"]
      }, function(tabs) {
        tabs.forEach(function(tab) {
          chrome.tabs.reload(tab.id);
        });
      });
      
      sendResponse({status: "success"});
    });
    return true; // Important: indicates async response
  }
});
EOF

echo -e "${GREEN}background.js dosyası oluşturuldu.${NC}"

# popup.html dosyasını oluştur
cat > "$PROJECT_DIR/popup.html" << EOF
<!DOCTYPE html>
<!-- 
  File: popup.html
  Path: /home/main/public_html/ai.zefre.net/eksi-blocker/popup.html
  Developer: gneral <gneral@gmail.com>
  Website: https://ai.zefre.net/
  R10 Profile: https://www.r10.net/profil/193-gneral.html
  GitHub: www.github.com/gneral
-->
<html lang="tr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Ekşi Sözlük Ad Blocker</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      width: 250px;
      padding: 15px;
      margin: 0;
      color: #333;
    }
    
    h1 {
      font-size: 16px;
      margin-top: 0;
      margin-bottom: 15px;
      text-align: center;
      color: #81C14B;
    }
    
    .toggle-container {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 15px;
      padding-bottom: 15px;
      border-bottom: 1px solid #eee;
    }
    
    .toggle-switch {
      position: relative;
      display: inline-block;
      width: 50px;
      height: 24px;
    }
    
    .toggle-switch input {
      opacity: 0;
      width: 0;
      height: 0;
    }
    
    .slider {
      position: absolute;
      cursor: pointer;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background-color: #ccc;
      transition: .4s;
      border-radius: 24px;
    }
    
    .slider:before {
      position: absolute;
      content: "";
      height: 16px;
      width: 16px;
      left: 4px;
      bottom: 4px;
      background-color: white;
      transition: .4s;
      border-radius: 50%;
    }
    
    input:checked + .slider {
      background-color: #81C14B;
    }
    
    input:checked + .slider:before {
      transform: translateX(26px);
    }
    
    .status {
      font-weight: bold;
    }
    
    .button {
      display: block;
      width: 100%;
      padding: 10px 0;
      margin-top: 10px;
      background-color: #81C14B;
      color: white;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      text-align: center;
      text-decoration: none;
    }
    
    .button:hover {
      background-color: #6BA53E;
    }
    
    .footer {
      margin-top: 20px;
      font-size: 11px;
      color: #999;
      text-align: center;
    }
  </style>
</head>
<body>
  <h1>Ekşi Sözlük Ad Blocker</h1>
  
  <div class="toggle-container">
    <span>Etkinleştir:</span>
    <label class="toggle-switch">
      <input type="checkbox" id="enabledToggle">
      <span class="slider"></span>
    </label>
  </div>
  
  <div id="statusText" class="status">Durum: Yükleniyor...</div>
  
  <a href="#" id="optionsBtn" class="button">Ayarlar</a>
  
  <div class="footer">
    Geliştirici: gneral &copy; 2025
  </div>
  
  <script src="popup.js"></script>
</body>
</html>
EOF

echo -e "${GREEN}popup.html dosyası oluşturuldu.${NC}"

# popup.js dosyasını oluştur
cat > "$PROJECT_DIR/popup.js" << EOF
// File: popup.js
// Path: /home/main/public_html/ai.zefre.net/eksi-blocker/popup.js
// Developer: gneral <gneral@gmail.com>
// Website: https://ai.zefre.net/
// R10 Profile: https://www.r10.net/profil/193-gneral.html
// GitHub: www.github.com/gneral

document.addEventListener('DOMContentLoaded', function() {
  const enabledToggle = document.getElementById('enabledToggle');
  const statusText = document.getElementById('statusText');
  const optionsBtn = document.getElementById('optionsBtn');
  
  // Load current state
  chrome.runtime.sendMessage({action: "getStatus"}, function(response) {
    if (response && response.hasOwnProperty('enabled')) {
      enabledToggle.checked = response.enabled;
      updateStatusText(response.enabled);
    }
  });
  
  // Toggle extension enabled state
  enabledToggle.addEventListener('change', function() {
    chrome.runtime.sendMessage({
      action: "toggleEnabled",
      enabled: enabledToggle.checked
    }, function(response) {
      if (response && response.status === "success") {
        updateStatusText(enabledToggle.checked);
      }
    });
  });
  
  // Open options page
  optionsBtn.addEventListener('click', function(e) {
    e.preventDefault();
    chrome.runtime.openOptionsPage();
  });
  
  // Update status text based on enabled state
  function updateStatusText(enabled) {
    if (enabled) {
      statusText.textContent = 'Durum: Aktif';
      statusText.style.color = '#81C14B';
    } else {
      statusText.textContent = 'Durum: Devre Dışı';
      statusText.style.color = '#999';
    }
  }
});
EOF

echo -e "${GREEN}popup.js dosyası oluşturuldu.${NC}"

# options.html dosyasını oluştur
cat > "$PROJECT_DIR/options.html" << EOF
<!DOCTYPE html>
<!-- 
  File: options.html
  Path: /home/main/public_html/ai.zefre.net/eksi-blocker/options.html
  Developer: gneral <gneral@gmail.com>
  Website: https://ai.zefre.net/
  R10 Profile: https://www.r10.net/profil/193-gneral.html
  GitHub: www.github.com/gneral
-->
<html lang="tr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Ekşi Sözlük Ad Blocker - Ayarlar</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      width: 100%;
      max-width: 500px;
      margin: 0 auto;
      padding: 20px;
      color: #333;
    }
    
    h1 {
      font-size: 20px;
      margin-top: 0;
      margin-bottom: 20px;
      color: #81C14B;
    }
    
    .option-container {
      margin-bottom: 15px;
      padding-bottom: 15px;
      border-bottom: 1px solid #eee;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    
    .option-info {
      flex-grow: 1;
    }
    
    .option-title {
      font-weight: bold;
      margin-bottom: 5px;
    }
    
    .option-description {
      font-size: 12px;
      color: #666;
    }
    
    .toggle-switch {
      position: relative;
      display: inline-block;
      width: 50px;
      height: 24px;
      margin-left: 20px;
    }
    
    .toggle-switch input {
      opacity: 0;
      width: 0;
      height: 0;
    }
    
    .slider {
      position: absolute;
      cursor: pointer;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background-color: #ccc;
      transition: .4s;
      border-radius: 24px;
    }
    
    .slider:before {
      position: absolute;
      content: "";
      height: 16px;
      width: 16px;
      left: 4px;
      bottom: 4px;
      background-color: white;
      transition: .4s;
      border-radius: 50%;
    }
    
    input:checked + .slider {
      background-color: #81C14B;
    }
    
    input:checked + .slider:before {
      transform: translateX(26px);
    }
    
    .actions {
      margin-top: 20px;
      text-align: right;
    }
    
    .button {
      padding: 8px 16px;
      background-color: #81C14B;
      color: white;
      border: none;
      border-radius: 4px;
      cursor: pointer;
    }
    
    .button:hover {
      background-color: #6BA53E;
    }
    
    .button.secondary {
      background-color: #ccc;
    }
    
    .button.secondary:hover {
      background-color: #bbb;
    }
    
    .footer {
      margin-top: 30px;
      font-size: 12px;
      color: #999;
      text-align: center;
    }
    
    .status-message {
      margin-top: 15px;
      padding: 8px;
      border-radius: 4px;
      text-align: center;
      display: none;
    }
    
    .status-message.success {
      background-color: #e8f5e9;
      color: #2e7d32;
      display: block;
    }
    
    .status-message.error {
      background-color: #ffebee;
      color: #c62828;
      display: block;
    }
  </style>
</head>
<body>
  <h1>Ekşi Sözlük Ad Blocker - Ayarlar</h1>
  
  <div id="statusMessage" class="status-message"></div>
  
  <div class="option-container">
    <div class="option-info">
      <div class="option-title">Alt Sabit Reklamları Engelle</div>
      <div class="option-description">Mobil görünümde sayfanın altında yer alan sabit reklamları engeller.</div>
    </div>
    <label class="toggle-switch">
      <input type="checkbox" id="blockBottomStickyAds">
      <span class="slider"></span>
    </label>
  </div>
  
  <div class="option-container">
    <div class="option-info">
      <div class="option-title">Kenar Çubuğu Reklamlarını Engelle</div>
      <div class="option-description">Sayfa kenarlarında yer alan reklam kutularını engeller.</div>
    </div>
    <label class="toggle-switch">
      <input type="checkbox" id="blockSidebarAds">
      <span class="slider"></span>
    </label>
  </div>
  
  <div class="option-container">
    <div class="option-info">
      <div class="option-title">İçerik İçi Reklamları Engelle</div>
      <div class="option-description">Entry'lerin arasında yer alan reklamları engeller.</div>
    </div>
    <label class="toggle-switch">
      <input type="checkbox" id="blockInlineAds">
      <span class="slider"></span>
    </label>
  </div>
  
  <div class="option-container">
    <div class="option-info">
      <div class="option-title">IFrame Reklamları Engelle</div>
      <div class="option-description">Google Topics ve diğer iframe reklamlarını engeller.</div>
    </div>
    <label class="toggle-switch">
      <input type="checkbox" id="blockIframes">
      <span class="slider"></span>
    </label>
  </div>
  
  <div class="actions">
    <button id="resetButton" class="button secondary">Varsayılana Sıfırla</button>
    <button id="saveButton" class="button">Kaydet</button>
  </div>
  
  <div class="footer">
    Ekşi Sözlük Ad Blocker v1.0.0<br>
    Geliştirici: gneral &copy; 2025
  </div>
  
  <script src="options.js"></script>
</body>
</html>
EOF

echo -e "${GREEN}options.html dosyası oluşturuldu.${NC}"

# options.js dosyasını oluştur
cat > "$PROJECT_DIR/options.js" << EOF
// File: options.js
// Path: /home/main/public_html/ai.zefre.net/eksi-blocker/options.js
// Developer: gneral <gneral@gmail.com>
// Website: https://ai.zefre.net/
// R10 Profile: https://www.r10.net/profil/193-gneral.html
// GitHub: www.github.com/gneral

document.addEventListener('DOMContentLoaded', function() {
  // Get elements
  const blockBottomStickyAds = document.getElementById('blockBottomStickyAds');
  const blockSidebarAds = document.getElementById('blockSidebarAds');
  const blockInlineAds = document.getElementById('blockInlineAds');
  const blockIframes = document.getElementById('blockIframes');
  const saveButton = document.getElementById('saveButton');
  const resetButton = document.getElementById('resetButton');
  const statusMessage = document.getElementById('statusMessage');
  
  // Load current settings
  loadSettings();
  
  // Save settings when Save button is clicked
  saveButton.addEventListener('click', function() {
    saveSettings();
  });
  
  // Reset to defaults when Reset button is clicked
  resetButton.addEventListener('click', function() {
    resetSettings();
  });
  
  // Load settings from storage
  function loadSettings() {
    chrome.storage.sync.get({
      blockBottomStickyAds: true,
      blockSidebarAds: true,
      blockInlineAds: true,
      blockIframes: true
    }, function(items) {
      blockBottomStickyAds.checked = items.blockBottomStickyAds;
      blockSidebarAds.checked = items.blockSidebarAds;
      blockInlineAds.checked = items.blockInlineAds;
      blockIframes.checked = items.blockIframes;
    });
  }
  
  // Save settings to storage
  function saveSettings() {
    const settings = {
      blockBottomStickyAds: blockBottomStickyAds.checked,
      blockSidebarAds: blockSidebarAds.checked,
      blockInlineAds: blockInlineAds.checked,
      blockIframes: blockIframes.checked
    };
    
    chrome.runtime.sendMessage({
      action: "updateSettings",
      settings: settings
    }, function(response) {
      if (response && response.status === "success") {
        showStatusMessage("Ayarlar başarıyla kaydedildi.", "success");
      } else {
        showStatusMessage("Ayarlar kaydedilirken bir hata oluştu.", "error");
      }
    });
  }
  
  // Reset settings to defaults
  function resetSettings() {
    const defaultSettings = {
      blockBottomStickyAds: true,
      blockSidebarAds: true,
      blockInlineAds: true,
      blockIframes: true
    };
    
    blockBottomStickyAds.checked = defaultSettings.blockBottomStickyAds;
    blockSidebarAds.checked = defaultSettings.blockSidebarAds;
    blockInlineAds.checked = defaultSettings.blockInlineAds;
    blockIframes.checked = defaultSettings.blockIframes;
    
    chrome.runtime.sendMessage({
      action: "updateSettings",
      settings: defaultSettings
    }, function(response) {
      if (response && response.status === "success") {
        showStatusMessage("Ayarlar varsayılana sıfırlandı.", "success");
      } else {
        showStatusMessage("Ayarlar sıfırlanırken bir hata oluştu.", "error");
      }
    });
  }
  
  // Show status message
  function showStatusMessage(message, type) {
    statusMessage.textContent = message;
    statusMessage.className = 'status-message ' + type;
    
    // Auto-hide after 3 seconds
    setTimeout(function() {
      statusMessage.className = 'status-message';
    }, 3000);
  }
});
EOF

echo -e "${GREEN}options.js dosyası oluşturuldu.${NC}"

# README.md dosyasını oluştur
cat > "$PROJECT_DIR/README.md" << EOF
# Ekşi Sözlük Ad Blocker

[![Geliştirici: gneral](https://img.shields.io/badge/Geli%C5%9Ftirici-gneral-81C14B.svg)](https://github.com/gneral)
[![Website: ai.zefre.net](https://img.shields.io/badge/Website-ai.zefre.net-81C14B.svg)](https://ai.zefre.net/)
[![R10: gneral](https://img.shields.io/badge/R10-gneral-81C14B.svg)](https://www.r10.net/profil/193-gneral.html)

Ekşi Sözlük reklam engelleme eklentisi, reklamsız bir deneyim yaşamanıza olanak tanır.

## Özellikler

- Alt sabit reklamları engeller (Mobil sayfada alt kısımda yer alan sabit reklamlar)
- Kenar çubuğu reklamlarını engeller
- İçerik içi reklamları engeller (Entry'lerin arasında yer alan reklamlar)
- IFrame reklamları engeller (Google Topics frame dahil)
- Ayarlar sayfası ile özelleştirilebilir yapılandırma
- Kullanım anında reklam engelleme performansı

## Kurulum

1. Bu GitHub deposunu indirin veya klonlayın
2. Chrome tarayıcınızda \`chrome://extensions\` adresine gidin
3. "Geliştirici modu"nu etkinleştirin (sağ üst köşe)
4. "Paketlenmemiş öğe yükle" butonuna tıklayın
5. İndirdiğiniz klasörü seçin
6. Eklenti tarayıcınıza yüklenecektir

## Kullanım

Eklenti, Ekşi Sözlük'ü ziyaret ettiğinizde otomatik olarak çalışır. Tarayıcı araç çubuğundaki simgeye tıklayarak aktif/pasif durumunu değiştirebilir veya ayarlar sayfasına erişebilirsiniz.

## Yapılandırma

Eklenti ayarları, hangi tür reklamların engelleneceğini özelleştirmenize olanak tanır:

- Alt sabit reklamlar
- Kenar çubuğu reklamları
- İçerik içi reklamlar
- IFrame reklamları

## İletişim

Herhangi bir sorun veya öneriniz varsa:
- Email: gneral@gmail.com
- GitHub: [github.com/gneral](https://github.com/gneral)
- Web: [ai.zefre.net](https://ai.zefre.net/)
- R10: [r10.net/profil/193-gneral.html](https://www.r10.net/profil/193-gneral.html)

## Lisans

Bu proje açık kaynak olarak geliştirilen bir yazılımdır.
EOF

echo -e "${GREEN}README.md dosyası oluşturuldu.${NC}"

# İlgili dosyaları ZIP arşivine sıkıştır
cd "$PROJECT_DIR"
find . -type f | grep -v "setup.sh" | xargs zip "$PROJECT_ZIP"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}ZIP arşivi oluşturuldu: $PROJECT_ZIP${NC}"
else
    echo -e "${RED}ZIP arşivi oluşturulurken hata oluştu!${NC}"
fi

# Kurulum bilgilerini göster
echo -e "\n${YELLOW}Kurulum Tamamlandı!${NC}"
echo "=============================="
echo -e "Proje dizini: ${GREEN}$PROJECT_DIR${NC}"
echo -e "ZIP arşivi: ${GREEN}$PROJECT_DIR/$PROJECT_ZIP${NC}"

# Kurulum talimatlarını göster
echo -e "\n${YELLOW}Chrome'a Yükleme Talimatları:${NC}"
echo "1. Chrome tarayıcınızda 'chrome://extensions' adresine gidin"
echo "2. Sağ üst köşedeki 'Geliştirici modu'nu etkinleştirin"
echo "3. 'Paketlenmemiş öğe yükle' butonuna tıklayın"
echo "4. Şu dizini seçin: $PROJECT_DIR"
echo "5. Eklenti tarayıcınıza yüklenecektir"

echo -e "\n${GREEN}Kurulum başarıyla tamamlandı!${NC}"
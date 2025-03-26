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
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
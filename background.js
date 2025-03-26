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
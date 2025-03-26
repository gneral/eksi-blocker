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
    style.textContent = `
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
    `;
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
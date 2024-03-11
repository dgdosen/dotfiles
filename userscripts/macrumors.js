// ==UserScript==
// @name         Filter Notices and JS-Notices on MacRumors
// @namespace    http://tampermonkey.net/
// @version      1.1
// @description  Hide notices and js-notices elements on MacRumors forums
// @author       Your Name
// @match        https://forums.macrumors.com/*
// @grant        none
// @run-at       document-idle
// ==/UserScript==

(function() {
  'use strict';

  // Function to hide elements with the specified classes
  const hideElements = () => {
    const style = document.createElement('style');
    style.type = 'text/css';
    style.innerHTML = `
            .notices, .js-notices { display: none !important; }
        `;
    document.head.appendChild(style);
  };

  // Run the function once on script start
  // this is a test
  hideElements();

  // No need for a MutationObserver here since we're using CSS to hide elements,
  // which will apply to any future elements automatically.
})();


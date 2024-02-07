// ==UserScript==
// @name         Windowed Luna
// @namespace    http://nachmore.com/
// @downloadURL  https://github.com/nachmore/ScriptBox/raw/master/TamperMonkey/windowed_luna.user.js
// @updateURL    https://github.com/nachmore/ScriptBox/raw/master/TamperMonkey/windowed_luna.user.js
// @version      0.1
// @description  Run Luna game streaming in windowed, and not fullscreen, mode
// @author       Oren Nachman
// @match        https://*luna.amazon.com/*
// @icon         data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🎮</text></svg>
// @grant        none
// ==/UserScript==

(function() {
  'use strict';
  // somewhere in Luna there is a line like this that is used to determine if full screen is available

  // return !(window.Cypress || v.globalStore.lunaState.isSmartTV || v.globalStore.lunaState.isSafariOnMobilePlatform && v.globalStore.lunaState.isTabletWeb || !document.fullscreenEnabled && !document.webkitFullscreenEnabled)

  // so the easiest way is to just set Cypress to true. This may be dangerous since Cypress is generally a testing mechanism
  // and the library may change, or it may enable other test only features that are not of interest.
  // window.Cypress = true;

  // The other alternative is to hard override document.fullscreenEnabled and document.webkitFullscreenEnabled
  Object.defineProperty(document, "fullscreenEnabled", { get() { console.log("****** fullscreen Enabled"); return false; }})
  Object.defineProperty(document, "webkitFullscreenEnabled", { get() { console.log("****** webkitFullscreenEnabled Enabled"); return false; }})

})();

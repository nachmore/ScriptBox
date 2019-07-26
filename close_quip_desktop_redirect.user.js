// ==UserScript==
// @name         Close Quip Desktop App redirect
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  Quip's redirect opens Quip links in the Desktop app but leaves the tab open. This closes them after 5 seconds.
// @author       Oren Nachman
// @include      /^https?://.*?quip.*?web-desktop-app-redirect\?/
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    window.setTimeout(function() { window.close(); }, 3000);
})();

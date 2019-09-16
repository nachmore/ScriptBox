// ==UserScript==
// @name         Remove annoying recently purchased popup from sollys.com.au
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  How annoying is that popup?
// @author       Oren Nachman
// @match        https://sollys.com.au/*
// @grant        none
// @require      https://gist.github.com/raw/2625891/waitForKeyElements.js
// ==/UserScript==

'use strict';

waitForKeyElements(".ak-master-sales-pop", hidePopup);

function hidePopup() {
    $(".ak-master-sales-pop").hide();
}

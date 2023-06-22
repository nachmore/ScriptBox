// ==UserScript==
// @name         Hide AWS Account Number
// @namespace    http://nachmore.com/
// @downloadURL  https://github.com/nachmore/ScriptBox/raw/master/TamperMonkey/redact_aws_account.user.js
// @updateURL    https://github.com/nachmore/ScriptBox/raw/master/TamperMonkey/redact_aws_account.user.js
// @version      0.1
// @description  redact AWS account numbers, useful for demos even though account numbers themselves are not considered particularly sensistive
// @author       Oren Nachman (https://github.com/nachmore/ScriptBox/tree/master/TamperMonkey)
// @match        https://*.console.aws.amazon.com/*
// @icon         https://console.aws.amazon.com/favicon.ico
// @grant        none
// @run-at       document-end
// @noframes
// @sandbox JavaScript
// ==/UserScript==

(function() {
  'use strict';

  function redactAccountSelector() {
    let navElem = document.querySelector('#nav-usernameMenu > span:nth-child(1) > span:nth-child(1)');

    if (navElem) {
      navElem.innerText = '[ Account ]';
      return true;
    }

    return false;
  }

  function waitForAccountSelector(records, observer) {
    if (redactAccountSelector()) {
      observer.disconnect();
    }
  }

  const observerOptions = {
    childList: true,
    subtree: true,
  };

  const observer = new MutationObserver(waitForAccountSelector);
  observer.observe(document, observerOptions);
})();

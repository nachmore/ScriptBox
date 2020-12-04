// ==UserScript==
// @name         Close Quip Desktop App redirect
// @namespace    http://tampermonkey.net/
// @version      0.3
// @description  Quip's redirect opens Quip links in the Desktop app but leaves the tab open. This closes them after 5 seconds.
// @author       Oren Nachman
// @include      /^https?://.*?quip.*?web-desktop-app-redirect\?/
// @grant        window.close
// ==/UserScript==

// Circle timer modified from https://www.cssscript.com/circular-countdown-timer-javascript-css3/ (MIT)

(function () {
  "use strict";

  function onTimerComplete() {
    window.setTimeout(function() { window.close(); }, 500);
  }

  injectTimerCSS();
  injectTimerHTML();

  let wholeTime = 5;

  //circle start
  let progressBar = document.querySelector(".e-c-progress");
  let indicator = document.getElementById("e-indicator");
  let pointer = document.getElementById("e-pointer");
  let length = Math.PI * 2 * 100;

  progressBar.style.strokeDasharray = length;

  //circle ends
  const displayOutput = document.querySelector(".display-remain-time");
  const pauseBtn = document.getElementById("pause");

  let intervalTimer;
  let timeLeft;
  let isPaused = false;
  let isStarted = false;

  update(wholeTime, wholeTime); //refreshes progress bar
  displayTimeLeft(wholeTime);

  pauseBtn.addEventListener("click", flipTimerState);

  pauseBtn.click();

  function update(value, timePercent) {
    var offset = -length - (length * value) / timePercent;
    progressBar.style.strokeDashoffset = offset;
    pointer.style.transform = `rotate(${(360 * value) / timePercent}deg)`;
  }

  function changeWholeTime(seconds) {
    if (wholeTime + seconds > 0) {
      wholeTime += seconds;
      update(wholeTime, wholeTime);
    }
  }

  function timer(seconds) {
    //counts time, takes seconds
    let remainTime = Date.now() + seconds * 1000;
    displayTimeLeft(seconds);

    intervalTimer = setInterval(function () {
      timeLeft = Math.round((remainTime - Date.now()) / 1000);
      if (timeLeft < 0) {
        clearInterval(intervalTimer);
        isStarted = false;

        pauseBtn.remove();

        onTimerComplete();

        displayTimeLeft(wholeTime);
        return;
      }
      displayTimeLeft(timeLeft);
    }, 1000);
  }

  function flipTimerState(event) {
    if (isStarted === false) {
      timer(wholeTime);
      isStarted = true;
      this.classList.remove("play");
      this.classList.add("pause");
    } else if (isPaused) {
      this.classList.remove("play");
      this.classList.add("pause");
      timer(timeLeft);
      isPaused = isPaused ? false : true;
    } else {
      this.classList.remove("pause");
      this.classList.add("play");
      clearInterval(intervalTimer);
      isPaused = isPaused ? false : true;
    }
  }

  function displayTimeLeft(timeLeft) {
    //displays time on the input
    let minutes = Math.floor(timeLeft / 60);
    let seconds = timeLeft % 60;
    let displayString = `${minutes < 10 ? "0" : ""}${minutes}:${
      seconds < 10 ? "0" : ""
    }${seconds}`;
    displayOutput.textContent = displayString;
    update(timeLeft, wholeTime);
  }

  function injectTimerCSS() {
    const style = document.createElement("style");
    style.textContent = `

#container {
  width: 150px;
  margin-left: auto;
  margin-right: auto;
  position: absolute;
  top: 0px;
  width: 100%;
}

#playpause-container {
  width: 30px;
  margin-left: auto;
  margin-right: auto;
}

#circle {
  text-align: center;
  margin-top: 20px;
}

.play {
  position: relative;
  left: -10px;
}

.timer-face {
  position: relative;
  top: -115px;
  text-align: center;
}

.display-remain-time {
  font-family: "Avenir Web",Sans-Serif;
  font-weight: 100;
  font-size: 30px;
  color: #F7958E;
}

#pause {
  outline: none;
  background: transparent;
  border: none;
  margin-top: 10px;
  width: 50px;
  height: 50px;
  left: -10px;
  position: relative;
}

.play::before {
  display: block;
  content: "";
  position: absolute;
  top: 8px;
  left: 16px;
  border-top: 15px solid transparent;
  border-bottom: 15px solid transparent;
  border-left: 22px solid #F7958E;
}

.pause::after {
  content: "";
  position: absolute;
  top: 8px;
  left: 12px;
  width: 15px;
  height: 30px;
  background-color: transparent;
  border-radius: 1px;
  border: 5px solid #F7958E;
  border-top: none;
  border-bottom: none;
}

#pause:hover { opacity: 0.8; }

.e-c-base {
  fill: none;
  stroke: #B6B6B6;
  stroke-width: 4px
}

.e-c-progress {
  fill: none;
  stroke: #F7958E;
  stroke-width: 4px;
  transition: stroke-dashoffset 0.7s;
}

.e-c-pointer {
  fill: #FFF;
  stroke: #F7958E;
  stroke-width: 2px;
}

#e-pointer { transition: transform 0.7s; }
`;
    document.head.append(style);
  }

  function injectTimerHTML() {
    document.body.innerHTML += `
    <div id="container">
      <div id="circle">
        <svg width="150" viewBox="0 0 220 220" xmlns="http://www.w3.org/2000/svg">
          <g transform="translate(110,110)">
            <circle r="100" class="e-c-base"/>
            <g transform="rotate(-90)">
              <circle r="100" class="e-c-progress"/>
              <g id="e-pointer">
                <circle cx="100" cy="0" r="8" class="e-c-pointer"/>
              </g>
            </g>
          </g>
        </svg>
      </div>
      <div class="timer-face">
        <div class="display-remain-time">00:00</div>
        <div id="playpause-container"><button class="play" id="pause"></button></div>
      </div>
    </div>`;
  }
})();

window.CountDownTimer = (function() {
  CountDownTimer.prototype.oneSecond = 1000;
  CountDownTimer.prototype.oneMinute = 1000 * 60;
  CountDownTimer.prototype.oneHour = 1000 * 60 * 60;
  CountDownTimer.prototype.oneDay = 1000 * 60 * 60 * 24;

  function CountDownTimer(selector) {
    this.el = $(selector);
    this.countUntil = Date.parse(this.el.data('until'));
    this.createElements();
    this.startCounting();
  }

  CountDownTimer.prototype.startCounting = function() {
    var _this = this
    this.interval = setInterval((function() {
      return _this.updateCountDown();
    }), this.oneSecond);
    return this.updateCountDown();
  };

  CountDownTimer.prototype.stopCounting = function() {
    return clearInterval(this.interval);
  };

  CountDownTimer.prototype.createElements = function() {
    var section, i, len, ref;
    ref = ['days', 'hours', 'minutes', 'seconds'];
    for (i = 0, len = ref.length; i < len; i++) {
      section = ref[i];
      this.el.append($("<span>", {
        "class": section + " clock"
      }));
      this.el.append(" " + section);
      if(section != "seconds"){
        this.el.append(", ");
      }
    }
    return this.updateCountDown();
  };

  CountDownTimer.prototype.timeLeft = function() {
    var days, hours, milliSecsLeft, minutes, now, seconds;
    now = new Date().getTime();
    milliSecsLeft = this.countUntil - now;
    if (milliSecsLeft < 0) {
      milliSecsLeft = 0;
      this.stopCounting();
      return false;
    } else {
      days = parseInt(milliSecsLeft / this.oneDay);
      hours = parseInt((milliSecsLeft % this.oneDay) / this.oneHour);
      minutes = parseInt(((milliSecsLeft % this.oneDay) % this.oneHour) / this.oneMinute);
      seconds = parseInt((((milliSecsLeft % this.oneDay) % this.oneHour) % this.oneMinute) / this.oneSecond);
      return {
        days: days,
        hours: hours,
        minutes: minutes,
        seconds: seconds
      };
    }
  };

  CountDownTimer.prototype.updateCountDown = function() {
    var section, time, ref, results;
    ref = this.timeLeft();
    if(!ref) {
      results = this.el.html("BLAST OFF!!!");
    } else {
      results = [];
      for (section in ref) {
        time = ref[section];
        results.push(this.write(section, time));
      }
    }
    return results;
  };

  CountDownTimer.prototype.write = function(section, number) {
    var hundreds, ones, sectionElement, tens;
    sectionElement = this.el.find(".clock." + section);
    if (parseInt(sectionElement.data('num')) === number) {
      return;
    }
    sectionElement.data('num', number);
    hundreds = parseInt(number / 100);
    tens = parseInt((number % 100) / 10);
    ones = parseInt(number % 10);
    sectionElement.html('');
    if (hundreds !== 0) sectionElement.append(hundreds);
    sectionElement.append(tens);
    return sectionElement.append(ones)
  };

  return CountDownTimer;

})();
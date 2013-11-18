$(document).ready(function() {
  window.timer = new CountDownTimer("#countdown");

  $('.content-body').initSimplyCountable('.redactor_editor');
})

$.fn.initSimplyCountable = function(child) {
  var countType = this.data('counttype');
  var maxCount = this.data('value');
  var operator = this.data('operator');
  this.find(child).simplyCountable({
    countType: countType,
    maxCount: maxCount,
    operator: operator
  });
}
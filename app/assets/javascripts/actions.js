$(document).ready(function() {
  window.timer = new CountDownTimer("#countdown");

  $('.content-body').initSimplyCountable('.redactor_editor');

  $('#toggle-content-body').on('click', function(e){
    e.preventDefault();
    $('.content-body.markedup').toggleClass('hide');
    $('.content-body.plain').toggleClass('hide');
    if($('#toggle-content-body .glyphicon').hasClass('glyphicon-check')){
      $('#toggle-content-body .glyphicon').removeClass('glyphicon-check').addClass('glyphicon-unchecked');
    } else {
      $('#toggle-content-body .glyphicon').removeClass('glyphicon-unchecked').addClass('glyphicon-check');
    }
  });
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
$(document).ready(function() {
  // RAILS FORM ERROR DISPLAY FOR BOOTSTRAP
  $('.has-error').parent('.form-group').not('.has-error').addClass('has-error');
  
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

  if($('body.csw-home').length > 0) {
    $(window).scroll(function(){
      var st = $(this).scrollTop()
        , opacity = 0 + (st/$('.csw-home-hero').height());
      $('.csw-content-header').setBackgroundAlpha(opacity);
    });
  }

});

$.fn.setBackgroundAlpha = function(opacity) {
  if (opacity > 1) opacity = 1
  var currentColor = this.css('background-color');
  var slicePoint = currentColor.substr(0,4) == "rgba" ? currentColor.lastIndexOf(',') : currentColor.lastIndexOf(')');
  var newColor = "rgba" + currentColor.slice(currentColor.lastIndexOf('('), slicePoint) + ", "+ opacity + ")";
  this.css('background-color', newColor);
}

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
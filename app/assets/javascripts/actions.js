$(document).ready(function() {
  // RAILS FORM ERROR DISPLAY FOR BOOTSTRAP
  $('.has-error').parent('.form-group').not('.has-error').addClass('has-error');
  
  window.timer = new CountDownTimer("#countdown");

  $('.content-body').initSimplyCountable('.redactor_editor');

  if($('body.csw-home').length > 0 && $('.csw-home-more').is(":visible") ) {
    $(window).scroll(function(){
      var st = $(this).scrollTop()
        , opacity = 0 + (st/$('.csw-home-hero').height());
      $('.csw-content-header').setBackgroundAlpha(opacity);
    });
  }

  $('.csw-navbar-toggle').on('click', function(){
    $('.csw-header-links').toggle();
  });

  $('.enquiry-form .csw-button').on('click', function(){
    $(this).val('Sending...');
  });

  // DOCUMENT IMPORT
  $(document).on('change', '.csw-button-file :file', function() {
    var label = $(this).val().replace(/\\/g, '/').replace(/.*\//, '');
    var output = $(this).parents('.csw-input-group').find(':text');
    output.val(label);
  });

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
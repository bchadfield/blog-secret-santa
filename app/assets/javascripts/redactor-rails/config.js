$(document).ready(function(){
  var csrf_token = $('meta[name=csrf-token]').attr('content');
  var csrf_param = $('meta[name=csrf-param]').attr('content');
  var params, interval;
  if (csrf_param !== undefined && csrf_token !== undefined) {
    params = csrf_param + '=' + encodeURIComponent(csrf_token);
  }
  $('.redactor').redactor(
    { 'path':'/assets/redactor-rails',
      'css':'style.css',
      buttons: ['html', '|', 'formatting', '|', 'bold', 'italic', 'underline', '|',
                'unorderedlist', 'orderedlist', '|', 'link', '|', 'alignment'],
      autoresize: false,
      autosave: window.location.href + '.json',
      autosaveInterval: 60, // seconds
      autosaveCallback: function(data) { successfulSave(); },
      changeCallback: function(html) { displayUnsavedMode(); }
    }
  );

  var savedHtml = $('.redactor').redactor('get');
  var unsaved = false;

  // Trigger unsaved mode when property input is changed
  $('form.edit_content .property-input').on('keyup', function(){
    $('.redactor').redactor('unsaved', true)
    displayUnsavedMode(true);
  });

  $('#save-content').on('click', function(){
    startingSave();
  });

  startingSave = function() {
    $('#save-content').removeClass('btn-success, btn-warning').addClass('btn-default');
    interval = setInterval(function() {
      $('#save-content').toggleClass('white-text');
    }, 250);
  }

  successfulSave = function() {
    clearInterval(interval);
    $('#save-content').removeClass('white-text').addClass('btn-success');
    savedHtml = $('.redactor').redactor('get');
  }

  displayUnsavedMode = function(triggered) {
    if($('.redactor').redactor('get') !== savedHtml || triggered == true) {
      $('#save-content').removeClass('btn-default, btn-success').addClass('btn-warning');
    }
  }
});

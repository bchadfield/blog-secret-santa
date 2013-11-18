$(document).ready(function(){
  var csrf_token = $('meta[name=csrf-token]').attr('content');
  var csrf_param = $('meta[name=csrf-param]').attr('content');
  var params, interval;
  if (csrf_param !== undefined && csrf_token !== undefined) {
    params = csrf_param + "=" + encodeURIComponent(csrf_token);
  }
  $('.redactor').redactor(
    { "path":"/assets/redactor-rails",
      "css":"style.css",
      buttons: ['html', '|', 'formatting', '|', 'bold', 'italic', 'underline', '|',
                'unorderedlist', 'orderedlist', '|', 'link', '|', 'alignment'],
      autoresize: false,
      autosave: window.location.href + ".json",
      autosaveInterval: 60, // seconds
      autosaveCallback: function(data) { successfulAutosave(); },
      changeCallback: function(html) { displayUnsavedMode(); }
    }
  );

  var savedHtml = $('.redactor').redactor('get');

  startingAutosave = function() {
    $("#save-content").removeClass("btn-success, btn-warning").addClass("btn-default");
    interval = setInterval(function() {
      $("#save-content").toggleClass("white-text");
    }, 250);
  }

  successfulAutosave = function() {
    clearInterval(interval);
    $("#save-content").removeClass("white-text").addClass("btn-success");
    savedHtml = $('.redactor').redactor('get');
  }

  displayUnsavedMode = function() {
    if($('.redactor').redactor('get') !== savedHtml) {
      $("#save-content").removeClass("btn-default, btn-success").addClass("btn-warning");
    }
  }
});

/*
* jQuery Simply Countable plugin
* Provides a character counter for any text input or textarea
* 
* @version  0.4.2
* @homepage http://github.com/aaronrussell/jquery-simply-countable/
* @author   Aaron Russell (http://www.aaronrussell.co.uk)
*
* Copyright (c) 2009-2010 Aaron Russell (aaron@gc4.co.uk)
* Dual licensed under the MIT (http://www.opensource.org/licenses/mit-license.php)
* and GPL (http://www.opensource.org/licenses/gpl-license.php) licenses.
*/

(function($){

  $.fn.simplyCountable = function(options){
    
    options = $.extend({
      counter:            '#counter',
      thousandSeparator:  ','
    }, options);

    var navKeys = [33,34,35,36,37,38,39,40];

    return $(this).each(function(){
      var countable = $(this);
      var counter = $(options.counter);
      if (!counter.length) { return false; }
      
      var countCheck = function(){
             
        var count;
        
        var numberFormat = function(ct){
          var prefix = '';
          if (options.thousandSeparator){
            ct = ct.toString();          
            // Handle large negative numbers
            if (ct.match(/^-/)) { 
              ct = ct.substr(1);
              prefix = '-';
            }
            for (var i = ct.length-3; i > 0; i -= 3){
              ct = ct.substr(0,i) + options.thousandSeparator + ct.substr(i);
            }
          }
          return prefix + ct;
        }

        var changeCountableValue = function(text){
          countable.text(text).trigger('change');
        }

        var cleanText = function () {
          return $.trim(countable.text().replace(/\t+/g, " ").replace(/\n/g, " ").replace(/\s+/g, " "));
        }
        
        var text = cleanText();
        /* Calculates count for either words or characters */
        count = text.length == 0 ? 0 : text.split(/\s+/).length
        counter.text(count + " words");
      };
      
      countCheck();

      countable.on('keyup blur paste', function(e) {
        switch(e.type) {
          case 'keyup':
            // Skip navigational key presses
            if ($.inArray(e.which, navKeys) < 0) { countCheck(); }
            break;
          case 'paste':
            // Wait a few miliseconds if a paste event
            setTimeout(countCheck, (e.type === 'paste' ? 5 : 0));
            break;
          default:
            countCheck();
            break;
        }
      });

    });
    
  };

})(jQuery);
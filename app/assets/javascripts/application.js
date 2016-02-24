// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_bootstrap_and_overrides
//= require turbolinks

(function(){
  $(window).scroll(function() {
  // check if window scroll for more than 430px. May vary
  // as per the height of your main banner.

    if($(this).scrollTop() > 20) {
        $('.navbar').addClass('opaque'); // adding the opaque class
    } else {
        $('.navbar').removeClass('opaque'); // removing the opaque class
    }
  });
})();
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
//= require turbolinks
//= require_tree .

$(document).ready( function() {

  src="//ajax.googleapis.com/ajax/libs/jqueryui/1.9.1/jquery-ui.min.js">

//  highlight an activity link on mouseover
  $('.activity-links a').on('mouseover', function() {
    $(this).toggleClass('highlight');
  });

  $('.activity-links a').on('mouseleave', function() {
    $(this).toggleClass('highlight');
  });

//// highlight table on mouseover
//  $('.table tr').on('mouseover', function() {
//    $(this).addClass('highlight-row');
//  });

//  console.log("Shazam");
//  $('input').on('click', function() {
//    console.log($(this));
//    $(this).prompt("Are sure you want to do this");
//  });


  $('.wager-border').on('click', function() {
    $(this).find('.wager-details').toggle();
    $(this).siblings().find('.wager-details').hide();

  });

  $('#proposed_wagers_table').selectable( function() {

  })

  //  $('#proposed_wagers_table').accordion({collapsible: true, active: false});
});
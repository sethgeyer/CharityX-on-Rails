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

  src="//ajax.googleapis.com/ajax/libs/jqueryui/1.9.1/jquery-ui.min.js"


  var wagers = $('#proposed_wagers_table .wager-border');

  wagers.each(function() {
    $wager = $(this);
    var outcome = $wager.find('.outcome')
    if (outcome.html() == 'I Lost!') {
      $wager.find('.outcome-flag').addClass('outcome-show-loss')
    }
    else if (outcome.html() == 'I Won!') {
      $wager.find('.outcome-flag').addClass('outcome-show-victory')
    }
    else  {
      $wager.find('.outcome-flag').addClass('outcome-show-pending')
    }
  });


  $('.expand-icon').on('click', function() {
    $(this).toggleClass('glyphicon-circle-arrow-down').toggleClass('glyphicon-circle-arrow-up')
    $(this).parents('.wager-border').find('.wager-details').toggle();
    $(this).parents('.wager-border').siblings().find('.wager-details').hide();
    $(this).parents('.wager-border').siblings().find('.expand-icon').removeClass('glyphicon-circle-arrow-up').addClass('glyphicon-circle-arrow-down');

  });


  $('.my-btn').on('mouseover', function() {
    $(this).toggleClass('my-active-btn')
  });

  $('.my-btn').on('mouseleave', function() {
    $(this).toggleClass('my-active-btn')
  })



//$('#proposed_wagers_table').selectable()





});
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
// require turbolinks
//= require_tree .

$(document).ready( function() {

//  Show an outcome flag based on whether the match has been won, lost or is still pending and highlight the row if the due date has passed.
  var wagers = $('#proposed_wagers_table .wager-border');
  wagers.each(function() {
    $wager = $(this);


    var outcome = $wager.find('.outcome');
    var date = $wager.attr('data-attribute-date');


    if (outcome.html() == null)  {
      $wager.find('.outcome-flag').addClass('outcome-show').addClass('pending');
    }
    else if (outcome.html().indexOf('I Lost!') != -1) {
      $wager.find('.outcome-flag').addClass('outcome-show').addClass('loss');
    }
    else if (outcome.html().indexOf('I Won!') != -1) {
      $wager.find('.outcome-flag').addClass('outcome-show').addClass('victory');
    }
    if (outcome.html() == null && date < 0) {
      $wager.addClass('past-due-outcome');
    }
  });


  $('.expand-icon').on('click', function() {
    $(this).toggleClass('glyphicon-th-list').toggleClass('glyphicon-circle-arrow-up')
    $(this).parents('.wager-border').find('.wager-details').toggle();
    $(this).parents('.wager-border').siblings().find('.wager-details').hide();
    $(this).parents('.wager-border').siblings().find('.expand-icon').removeClass('glyphicon-circle-arrow-up').addClass('glyphicon-th-list');

  });


  $('.my-btn').on('mouseover', function() {
    $(this).toggleClass('my-active-btn')
  });

  $('.my-btn').on('mouseleave', function() {
    $(this).toggleClass('my-active-btn')
  })



$('.wager-border').draggable()



});
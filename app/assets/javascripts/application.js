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
//= require moment
//= require bootstrap-datetimepicker



$(document).ready( function() {

//  var inputGameID= $('.game-id-container').val()
//  if (inputGameID != "") {
//    $('.wager-date-input').prop('readonly', true)
//    $('.wager-details-input').prop('readonly', true)
//    $('.wager-input').prop('readonly', true)
//    $('#datetimepicker6').data("DateTimePicker").disable();
//
//    $('.wager-date-input').removeProp('disabled');
//    $('.wager-date-input').prop('readonly', true);
//  }









//  User can select sport games from the modal and the information is auto-populated into the wager form
  $('.modal-body a').on('click', function(event) {
    event.preventDefault()

    var $selectedTeam = $(this)

    var selectedTeamName = $selectedTeam.text()
    var selectedWinnerID = $selectedTeam.attr('data-team-id')

    var loserName = $selectedTeam.siblings('a')[0].text
    var gameContainer = $selectedTeam.parents('.game-container')
    var gameID = gameContainer.attr('data-game-id')
    var gameWeek = gameContainer.attr('data-game-week')

    var homeTeam = gameContainer.attr('data-home-team-id')
    var visitingTeam = gameContainer.attr('data-vs-team-id')

    var inputWagerField = $('.wager-input')
    var inputWagerDateField = $('.wager-date-input')
    var inputWagerDetailsField = $('.wager-details-input')

    inputWagerField.val('The ' + selectedTeamName + ' beat the ' + loserName)

    var gameDate = gameContainer.attr('data-game-date')

    var gameTemperature = gameContainer.attr('data-game-temperature')
    var gameCondition = gameContainer.attr('data-game-condition')
    var gameLocation = gameContainer.attr('data-game-location')

    if (gameCondition != "") {
      var gameForecast = " / Forecast: " + gameTemperature + " and " + gameCondition
    }
    else {
      var gameForecast = ""
    }
    inputWagerDateField.val(gameDate)



    inputWagerField.siblings('.game-id-container').val(gameID)
    inputWagerField.siblings('.selected-winner-container').val(selectedWinnerID)
    inputWagerField.siblings('.week-container').val(gameWeek)

    inputWagerField.siblings('.home-id-container').val(homeTeam)
    inputWagerField.siblings('.visitor-id-container').val(visitingTeam)




    inputWagerDetailsField.val("@" + gameLocation + gameForecast)



    $('#datetimepicker6').data("DateTimePicker").disable();

    inputWagerDateField.removeProp('disabled');
    inputWagerDateField.prop('readonly', true);
    inputWagerField.prop('readonly', true);

    $('#myModal').modal("hide")
    inputWagerDetailsField.prop('readonly', true)

  })












//  Show an outcome flag based on whether the match has been won, lost or is still pending and highlight the row if the due date has passed.
  var wagers = $('#wagers_table .wager-border');
  wagers.each(function() {
    $wager = $(this);


    var outcome = $wager.find('.outcome');
    var date = $wager.attr('data-attribute-date');
    var status = $wager.attr('data-attribute-status');


    if (outcome.html() == null && date < 0) {
      $wager.addClass('past-due-outcome');
      $wager.find(".wager-actions").append("Did you when this bet?  Check the outcome or tell me if you won or lost.")
    };

  });

  $('.expand-icon').on('click', function() {
    $(this).toggleClass('glyphicon-th-list').toggleClass('glyphicon-circle-arrow-up')
    $(this).parents('.wager-border').find('.wager-details').toggle();
    $(this).parents('.wager-border').siblings().find('.wager-details').hide();
    $(this).parents('.wager-border').siblings().find('.expand-icon').removeClass('glyphicon-circle-arrow-up').addClass('glyphicon-th-list');

  });


  $('.table-expand-icon').on('click', function() {
    $(this).toggleClass('glyphicon-th-list').toggleClass('glyphicon-circle-arrow-up')
    var contentsSection = $(this).parents('.blue-bordered').children('.summary-total')
    contentsSection.toggleClass('expanded-contents')
    var $selectedDropDownDetail = $(this).parents('.blue-bordered').children('.drop-down-detail')
    $selectedDropDownDetail.toggle();
  });


//
//    $(this).parents('.wager-border').siblings().find('.wager-details').hide();
//    $(this).parents('.wager-border').siblings().find('.expand-icon').removeClass('glyphicon-circle-arrow-up').addClass('glyphicon-th-list');




  $('.delete-icon').on('click', function() {
    var $xButton = $(this)
    var archiveMessage = "<div class='archive' style='color:red'>This wager is being archived</div><br/>"
    var wagerID = $xButton.attr('data-id')
    var postWagerPreferencePromise = $.post("/user/wager_view_preferences", {wager_id: wagerID})


    postWagerPreferencePromise.success( function() {

      $xButton.parents('.wager-border').after(archiveMessage);
      $('.archive').fadeOut(2000)
      $xButton.parents('.wager-border').fadeOut(2000)



    });


  });



  $('.wager-title').on('mouseover', function() {
    $(this).toggleClass('active-wager')
  });

  $('.wager-title').on('mouseleave', function() {
    $(this).toggleClass('active-wager')
  })




  $('.button').on('mouseover', function() {
    $(this).toggleClass('active-button')
  });

  $('.button').on('mouseleave', function() {
    $(this).toggleClass('active-button')
  })


  var wagerNotes = $('.wager-notes')
  var questionButton = $('.question')

  questionButton.on("click", function() {
    $(this).parents('#new_proposed_wagers').find('.wager-notes').toggle()
  })


});
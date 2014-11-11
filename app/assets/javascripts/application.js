// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require      jquery
//= require      jquery_ujs
//= require      foundation
//= require      sugar
//= require      ./lib/jquery/jquery.ui.widget
//= require_tree ./lib

//= require      ./app/optimizeplayer
//= require_tree ./app/controllers
//= require_tree ./app/services
//= require_tree ./app/directives
//= require_tree ./app/filters
//= require_tree ./app/modules

//= require_tree ./embed

//= require      ./preview_page.coffee
//= require_tree ./pages
//= require      redactor-rails
//= require      redactor-rails/config
//= require zeroclipboard

(function(jQuery) {
  // set the x-csrf-token for each ajax operation
  // rack / rack_csrf handle the rest
  jQuery.ajaxSetup({
    beforeSend: function(xhr) {
      var token = jQuery('meta[name="csrf-token"]').attr('content');
      xhr.setRequestHeader('X-CSRF-TOKEN', token);
    }
  });
}(jQuery));

$(document).on("click", '#add_team_member', function(){
  $('#account .team .invite').slideDown(500);
  return false;
});

function loadNotifications() {
  $.get("/notifications.js");
}

$(document).on("click", '.confirm', function(e){
  id = e.target.id;
  $.when($.post("/notifications/" + id + "/mark_as_read.json"))
    .then(function(data) {
      loadNotifications();
    });
});

$(document).ready(function () {

  //for copying to clipboard
  var clip = new ZeroClipboard($(".clip_button"));
  ZeroClipboard.on("aftercopy", function(e) {
    e.target.innerHTML = "Copied"
    setTimeout(function() {
      e.target.innerHTML = "Copy"
    }, 2000);
  });

  //Fix Sidebar Height
  $(window).load(function(){ //wait to load the images too
    if($('[role=sidebar]').length > 0){
      sidebar = $('[role=sidebar]').outerHeight(true);
      wrap = $('.wrap').outerHeight(true);
      if(sidebar < wrap){
        $('[role=sidebar]').height(wrap);
      }else{
        $('[role=sidebar]').height('auto');
      }
    }
  });

  //load all notifications
  loadNotifications();

  $('#dropzone').bind('dragover', function (e) {
    $('#dropzone').addClass('drag-hover');
  });

  $('#dropzone').bind('dragleave', function (e) {
    $('#dropzone').removeClass('drag-hover');
  });

  $(document).on("click", '#update-user',  function(){
    $('form.user-info').submit();
  });

  // Animate the sidebar in Projects
  projects = $('section[role=projects]');
  selector = $('> .header ul li a, .sidebar > ul >li > a', projects)
  $(document).on("click", selector, function(e){
    if ($(e.target).attr('href') && $(e.target).attr('href')[0] == '#') {
      target = $(e.target).attr('href').replace("#","");

      if (target.length > 0){
        if($(e.target).parent().hasClass('selected')){
          $(e.target).parent().removeClass('selected');
          $('.cta-options', projects).removeClass('open');
          $('.video-content', projects).removeClass('open');
        }else{
          $('> .header ul li', projects).removeClass('selected');
          if($(e.target).parents('.header').length > 0){
            $(e.target).parent().addClass('selected');
          }
          $('.cta-options', projects).addClass('open');
          $('.video-content', projects).addClass('open');
          $('.cta-options .sidebar', projects).hide();
          $('.cta-options .sidebar.'+target, projects).show();
        }
        return false;
      }
    }
  });

  // Change Card Flag
  $('.card-number input[type=text]').on('keyup', function(){
    number = $(this).val().charAt(0);
    card = '';
    switch(number){
      case '3':
        card = 'amex';
        break;
      case '4':
        card = 'visa';
        break;
      case '5':
        card = 'master';
        break;
      case '6':
        card = 'discover';
        break;
    }
    $(this).siblings('.flag').attr('class', 'flag ' + card);
  });

  // Custom Slider
  $('.slider-range').slider();

  // Custom Checkbox and Radio Button
  $('input.pretty').prettyCheckable();

  $('select[selectpicker]').selectpicker();
  $('select[selectpicker]').selectpicker('refresh');

  // Remove Class from Header After Close Notifications
  $('#modal-notifications').on('hidden.bs.modal', function (e) {
    $('#modal-notifications .close-notifications').click();
  })

  // Tooltip
  $('.use-tooltip').on('mouseenter', function(){
    var type = $(this).data('tooltip');
    var title = $(this).data('title');
    var tooltip = $('#tooltip-' + type);
    $(this).append(tooltip);
    $(tooltip).find('span').html(title).end().stop().fadeIn(250);
  }).on('mouseleave', function(){
    var tooltip = $(this).data('tooltip');
    $('#tooltip-' + tooltip).stop().fadeOut(250);
  });

});

//= require jquery
//= require jquery_ujs
//= require jquery.tools.min
//= require jquery.endless-scroll
//= require swfobject
//= require jquery.uploadify.min
//= require jquery.focusend
//= require cocoon
//= require theme
//= require_self


// Function to rebind all important UI events after DOM updates
function rebindToDOM(){
  var scrollLock = true;
  $('.updates').endlessScroll({
    fireOnce: true,
    fireDelay: 1500,
    ceaseFire: function(){
      return $('#infinite-scroll').length ? false : true;
    },
    bottomPixels:300,
    callback: function(){
      if (scrollLock){
        scrollLock = false;
        $.ajax({
          method: 'GET',
          url: $(this).data('url'),
          data: {
            last: $(this).data('last')
          },
          dataType: 'script',
          success: function(data, status){
            scrollLock = true;
          }
        });
      }

    }
  });
  $('.endless').endlessScroll({
    fireOnce: true,
    fireDelay: 1500,
    ceaseFire: function(){
      return $('#infinite-scroll').length ? false : true;
    },
    bottomPixels:300,
    callback: function(fireSequence){
      if (scrollLock){
        scrollLock = false;
        $.ajax({
          method: 'GET',
          url: $(this).data('url'),
          data: {
            page: fireSequence + 1,
            search: $('#search').val()
          },
          dataType: 'script',
          success: function(data, status){
            scrollLock = true;
          }
        });
      }
    }
  });
  
  $("a.overlay[rel]").overlay({
    effect: 'apple',
    onBeforeLoad: function() {
      var wrap = this.getOverlay().find(".contentWrap");
      wrap.load(this.getTrigger().attr("href"));
    }
  });
  
  $("a.full_overlay[rel]").overlay({
    effect: 'apple',
    top: -15,
    onBeforeLoad: function() {
      var wrap = this.getOverlay().find(".contentWrap");
      wrap.load(this.getTrigger().attr("href"));
    }
  });
  
  $('[title]:not(abbr)').tooltip({effect: 'slide', offset: [-14, 0]});
}

$(function(){
  
  rebindToDOM();
  
  /******* General Code *******/
  
  if ($('#activate-new-group').length){
    $('#new-group-button').click();
  }
  
  $("img.loading").ajaxStart(function(){
    $(this).removeClass('none');
  }).ajaxComplete(function(){
    $(this).addClass('none');
  });
    
  $('#new-document-comment').keyup(function() {
    if ($(this).val().length > 42){
      $(this).replaceWith('<textarea name=text id=new-document-comment>'+$(this).val()+'</textarea>');
      $('#new-document-comment').focusEnd();
    }
  });
  
  $("#group-breadcrumb").live('click', function() {
    $('#slide-content').slideUp('slow');
    $('#group-show').slideDown('slow');
    $('#group-tips').slideDown();
    $('#forum-tips').slideUp();
  });
    
  /******* Filters *******/
  
  $(".filters > a").live('click', function() {
    $(".filters a").removeClass('button-green');
    $(this).addClass('button-green');
    var url = $(this).data('url');
    if (url && url !== ''){
      $.getScript($(this).data('url'), function(data, status){
        rebindToDOM();
      });
    }
    return false;
  });
  
  $("#account-filters a").click(function(){
    $('#account').slideUp();
    $('#personal').slideUp();
    $('#options').slideUp();
    $('#' + $(this).data('target')).slideDown();
  });
  
  $(".doc-filters a").live('click', function(){
    $('#new-docs').slideUp();
    $('#collection-docs').slideUp();
    $('#' + $(this).data('target')).slideDown();
  });
  
  /******* Group forums *******/

  $('.reply-to').live('click',function(){
    var post = $(this).closest('.post');
    var id = post.attr('id');
    $('#in-reply-to').slideDown('slow');
    $('#reply').slideUp('slow');
    $('#reply-text').html(post.find('.text').html());
    $('#reply-author').text(post.find('.author').text());
    $('#parent_id').val(id);
    $('html, body').animate({scrollTop: $('body').height()}, 800);
  });
  
  $('#cancel-reply').live('click', function(){
   $('#in-reply-to').slideUp('slow');
   $('#reply').slideDown('slow');
   $('#parent_id').val('');
  });
  
  $('.edit-post').live('click', function(){
    var post = $(this).closest('.post');
    var id = post.attr('id');
    var form = $('#edit-'+id);
    form.removeClass('none');
    post.find('.text').addClass('none');
    post.find('.actions').addClass('none');
  });
  
  $('.cancel-edit-form').live('click', function(){
    var post = $(this).closest('.post');
    $(this).closest('form').addClass('none');
    post.find('.text').removeClass('none');
    post.find('.actions').removeClass('none');
  });
  
  $('.edit-topic').live('click', function(){
    var topic = $(this).closest('.topic');
    var id = topic.attr('id');
    var form = $('#edit-'+id);
    form.removeClass('none');
    topic.find('.title').addClass('none');
  });
    
    
});


/******* Helper Functions *******/

function toggleNone(elements){
  $.each(elements, function (index, element){
    if ($(element).hasClass('none-i')){
      $(element).removeClass('none-i');
    }else{
      $(element).addClass('none-i');
    }
  });
}

function slideContent(content, showGroupTips){
  $('#slide-content').slideUp('slow', function() {
    $('#group-show').slideUp('slow');
    $('#slide-content').html(content);
    rebindToDOM();
    $('#slide-content').slideDown('slow');
    if (!showGroupTips){
      $('#group-tips').slideUp();
      $('#forum-tips').slideDown();
    }
  });
}
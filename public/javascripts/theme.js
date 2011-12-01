// HTML5 placeholder plugin version 0.3
// Enables cross-browser* html5 placeholder for inputs, by first testing
// for a native implementation before building one.
//
// USAGE: 
//$('input[placeholder]').placeholder();

(function($){
  
  $.fn.placeholder = function(options) {
    return this.each(function() {
      if ( !("placeholder"  in document.createElement(this.tagName.toLowerCase()))) {
        var $this = $(this);
        var placeholder = $this.attr('placeholder');
        $this.val(placeholder).data('color', $this.css('color')).css('color', '#aaa');
        $this
          .focus(function(){ if ($.trim($this.val())===placeholder){ $this.val('').css('color', $this.data('color')); } })
          .blur(function(){ if (!$.trim($this.val())){ $this.val(placeholder).data('color', $this.css('color')).css('color', '#aaa'); } });
      }
    });
  };
}(jQuery));

var menuYloc = null;
var previewYloc = null;

// perform JavaScript after the document is scriptable.
$(document).ready(function() {

    /**
     * Setup Tooltips
     */
    // this set's up the sidebar tooltip for the recent contacts
    $('.recent a').tooltip({
        position: 'center right', // position it to the right
        effect: 'slide', // add a slide effect
        offset: [30,15], // adjust the position 30 pixels to the top and 19 pixels to the left
        onBeforeShow: function() {
            this.getTip().appendTo('body');
        }
    });
    
    $('.other-options a').tooltip({
        position: 'center left', // position it to the right
        effect: 'slide', // add a slide effect
        offset: [30, -45], // adjust the position 30 pixels to the top and 19 pixels to the left
        onBeforeShow: function() {
            this.getTip().appendTo('body');
        }
    });

    // html element for the help popup
    $('body').append('<div class="apple_overlay black" id="overlay"><div class="contentWrap" style="width: 100%; height: 500px;overflow:auto;background:#8EC2DA;"></div>');
    $('body').append('<div class="scribd_overlay" id="scribd_overlay"><div class="contentWrap" style="width: 100%; height:645px;overflow:auto;background:#8EC2DA;"></div>');

    /**
     * Setup Tabs
     */
    $("ul.tabs").tabs("div.panes > section");
    
    /**
     * Setup placeholder for text input
     */
    $('input[placeholder]').placeholder();

    // attach calendar to date inputs
    $(":date").dateinput({
        format: 'mm/dd/yyyy',
        trigger: false
    });

    // add close buttons to closeable message boxes
    $(".message.closeable").prepend('<span class="message-close"></span>')
        .find('.message-close')
        .click(function(){
            $(this).parent().fadeOut(function(){$(this).remove();});
        });

    // setup popup balloons (add contact / add task)
    $('.has-popupballoon').click(function(){
        // close all open popup balloons
        $('.popupballoon').fadeOut();
        $(this).next().fadeIn();
        return false;
    });

    $('.popupballoon .close').click(function(){
        $(this).parents('.popupballoon').fadeOut();
    });

    // preview pane setup
    
    $('.list-view > li a:not([data-remote])').live('click', function(e){ e.stopPropagation();});
    
    $('.list-view li:not(.post), .post .content').live('click', function(){
        var url = $(this).find('.more').attr('href');
        if (!$(this).hasClass('current')) {
            $('.preview-pane .preview').animate({left: "-375px"}, 300, function(){
                $(this).animate({left: "-22px"}, 500).html('<div class="center"><img src="/images/loading.gif"/></div>');
                $.getScript(url);
            });
        } else {
            $('.preview-pane .preview').animate({left: "-375px"}, 300);
        }
        $(this).toggleClass('current').siblings().removeClass('current');
        //return false;
    });
    
    $('.activate-preview').live('click', function() {
      $('.preview-pane .preview').animate({left: "-375px"}, 300, function(){
          $(this).animate({left: "-22px"}, 500).html('<div class="center"><img src="/images/loading.gif"/></div>');
      });
      return false;
    });
    
    $('.list-view li .more').live('click', function(){
      $(this).parent().click();
      return false;
    })
    
    $('.preview-pane .preview .close').live('click', function(){
        $('.preview-pane .preview').animate({left: "-375px"}, 300);
        $('.list-view li').removeClass('current');
        return false;
    });
    // preview pane setup end

    // floating menu and preview pane
    if ($('#wrapper > header').length>0) { menuYloc = parseInt($('#wrapper > header').css("top").substring(0,$('#wrapper > header').css("top").indexOf("px")), 10); }
    if ($('.preview-pane .preview').length>0) { previewYloc = parseInt($('.preview-pane .preview').css("top").substring(0,$('.preview').css("top").indexOf("px")), 10); }
    $(window).scroll(function () {
        var offset = 0;
        if ($('#wrapper > header').length>0) {
            offset = menuYloc+$(document).scrollTop();
            if (!$.browser.msie) { $('#wrapper > header').animate({opacity: ($(document).scrollTop()<=10? 1 : 0.8)}); }
        }
        if ($('.preview-pane .preview').length>0) {
            offset = previewYloc+$(document).scrollTop()+400>=$('.main-section').height()? offset=$('.main-section').height()-400 : previewYloc+$(document).scrollTop();
            $('.preview-pane .preview').animate({top:offset},{duration:500,queue:false});
        }
    });

    if (!$.browser.msie) {
        $('#wrapper > header').hover(
            function(){$(this).animate({opacity: 1});},
            function(){$(this).animate({opacity: ($(document).scrollTop()<=10? 1 : 0.8)});}
        );
    }

    // Regular Expression to test whether the value is valid
    $.tools.validator.fn("[type=time]", "Please supply a valid time", function(input, value) { 
        return (/^\d\d:\d\d$/).test(value);
    });

    $.tools.validator.fn("[data-equals]", "Value not equal with the $1 field", function(input) {
        var name = input.attr("data-equals"),
        field = this.getInputs().filter("[name=" + name + "]"); 
        return input.val() === field.val() ? true : [name]; 
    });
     
    $.tools.validator.fn("[minlength]", function(input, value) {
        var min = input.attr("minlength");
        
        return value.length >= min ? true : {     
            en: "Please provide at least " +min+ " character" + (min > 1 ? "s" : "")
        };
    });
        
    $.tools.validator.localizeFn("[type=time]", {
        en: 'Please supply a valid time'
    });
     
    // setup the validators
    $(".form").validator({ 
        position: 'left', 
        offset: [25, 10],
        messageClass:'form-error',
        message: '<div><em/></div>' // em element is the arrow
    }).attr('novalidate', true);

    // setup the view switcher
    $('.main-content > header .view-switcher > h2 > a').click(function(){
        $(this).focus().parent().next().fadeIn();
        return false;
    }).blur(function(){
        $(this).parent().next().fadeOut();
        return false;
    });

    // promo closer
    $('#promo .close').click(function(){
        $('#promo').slideUp();
        $('body').removeClass('has-promo');
    });
});

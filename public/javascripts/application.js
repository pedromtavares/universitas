var scrollLock = true;

var updatesOptions = {
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
		    url: $(this).data('url'),
		    data: {
				  last: $(this).attr('last')			
			  },
        dataType: 'script',
        success: function(data, status){
          scrollLock = true;
        }
		  });
    }
    
  }
}

var endlessOptions = {
	fireOnce: true,
	fireDelay: 1500,
	ceaseFire: function(){
		return $('#infinite-scroll').length ? false : true;
	},
	bottomPixels:300,
  callback: function(fireSequence){
    $.ajax({
	    url: $(this).data('url'),
	    data: {
			  page: fireSequence + 1,
			  search: $('#search').val()
		  },
		  dataType: 'script'
	  });
  }
}

$(function(){
	
	/******* General Code *******/
	
	$("img.loading").ajaxStart(function(){
		$(this).removeClass('none');
	}).ajaxComplete(function(){
		$(this).addClass('none');
	});
	
	/******* Endless Scroll *******/
	
	$('.updates').endlessScroll(updatesOptions);
	
	$('.endless').endlessScroll(endlessOptions);
	
	/******* Filters *******/
  
  $(".filters > a").click(function() {
    $(".filters a").removeClass('button-green');
    $(this).addClass('button-green');
    var url = $(this).data('url');
    if (url && url!=''){
      $.getScript($(this).data('url'), function(data, status){
        $('.endless').endlessScroll(endlessOptions);
        $('.updates').endlessScroll(updatesOptions);
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
	
	/******* Group document sharing UI *******/
	
	$("#search-docs .doc .options a").live('click', function(event){
		var target = $(event.target).parent();
		var doc = target.parent().parent();
		var array = target.attr('id').split('_');
		var id = array[1];
		if (array[0] == 'add'){
			chosen = $('#remove_'+id);
			if (chosen.length == 0){
				$('#message').hide();
				$('#chosen-form').show();
				$('#chosen-docs').append(target.attr('chosen'));
			}
			doc.detach();	
		}
	});
	
	$("#chosen-form .doc .options a").live('click', function(event){
		var target = $(event.target).parent();
		var doc = target.parent().parent();
		$(doc).detach();
		if ($('#chosen-form .doc').length == 0){
			$('#chosen-form').hide();
		}
	});
	
	/******* Group document management UI *******/
	
	$(".table .edit-module").live('click', function(){
		var td = $(this).closest('tr').find('.module');
		td.find('.update-module').removeClass('none');
		td.find('.name').addClass('none');
	});
	
	$(".table .update-module").change(function(){
		$(this).closest('form').submit();
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
		var post = $(this).closest('.post')
		var id = post.attr('id');
		var form = $('#edit-'+id);
		form.removeClass('none');
		post.find('.text').addClass('none');
		post.find('.actions').addClass('none');
	});
	
	$('.cancel-edit-form').live('click', function(){
		var post = $(this).closest('.post')
		$(this).closest('form').addClass('none');
		post.find('.text').removeClass('none');
		post.find('.actions').removeClass('none');
	});
	
	$('.edit-topic').live('click', function(){
		var topic = $(this).closest('.topic')
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

function slideToAction(action, callback){
  var actions = ['forums', 'new', 'edit', 'forum_show', 'posts', 'new_topic', 'group_show'];
  $.each(actions, function(index, value) {
    if (value != action){
      $('#'+value).slideUp();
    }
  });
  callback();
  $('#'+action).slideDown();
  $('.endless').endlessScroll(endlessOptions);
}

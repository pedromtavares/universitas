$(function(){
	
	/******* General Code *******/
	
	$('.updates').endlessScroll({
		fireOnce: true,
		fireDelay: 1500,
		ceaseFire: function(){
			return $('#infinite-scroll').length ? false : true;
		},
		bottomPixels:500,
	  callback: function(){
	    $.ajax({
		  url: $(this).data('url'),
		  data: {
				last: $(this).data('last'),
				type: $(this).data('type')
			},
			dataType: 'script'
		 });
	  }
	});
	
	$('.endless').endlessScroll({
		fireOnce: true,
		fireDelay: 1500,
		ceaseFire: function(){
			return $('#infinite-scroll').length ? false : true;
		},
		bottomPixels:500,
	  callback: function(){
	    $.ajax({
		  url: $(this).data('url'),
		  data: {
				page: $(this).data('page'),
			},
			dataType: 'script'
		 });
	  }
	});
	
	$("img.loading").ajaxStart(function(){
		$(this).removeClass('none');
	}).ajaxComplete(function(){
		$(this).addClass('none');
	});
	
	/******* Updates *******/
  
  $("#update-filters > a").click(function() {
    showUpdatesFor($(this).attr('target'), true);
    $("#update-filters a").removeClass('button-green');
    $(this).addClass('button-green');
    return false;
  });
    
  showUpdatesFor('all');
  
	
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
		$('#in-reply-to').removeClass('none');
		$('#reply').addClass('none');
		$('#in-reply-to').find('p').html(post.find('.content').html());
		$('#parent_id').val(id);
	});
	
	$('#cancel-reply').click(function(){
		$('#in-reply-to').addClass('none');
		$('#reply').removeClass('none');
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

function showUpdatesFor(type, fadeIn){
	if(type == '' || !type){type = 'all'}
	$('#latest-updates > div').hide();
  if (fadeIn){
    $('#'+type).fadeIn('slow');
  }else{
    $('#'+type).show();
  }
	list = $('#'+type+' .updates');
	list.find('li').hide();
	switch(type){
		case 'user':
			list.find('[creator=user]').show();
			break;
		case 'group':
			list.find('[creator=group]').show();
			break;
		case 'forum':
			list.find('[creator=forum]').show();
			break;
		default:
			list.find('li').show();
	}
}

function toggleNone(elements){
	$.each(elements, function (index, element){
		if ($(element).hasClass('none-i')){
			$(element).removeClass('none-i');
		}else{
			$(element).addClass('none-i');
		}
	});
}

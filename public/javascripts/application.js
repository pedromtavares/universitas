$(function(){
	
	/******* General Code *******/
	
	$('.updates').endlessScroll({
		fireOnce: true,
		fireDelay: 1500,
		ceaseFire: function(){
			return $('#infinite-scroll').length && !$(this).closest('.ui-tabs-panel').hasClass('ui-tabs-hide') ? false : true;
		},
		bottomPixels:500,
	  callback: function(){
	    $.ajax({
		  url: $(this).attr('url'),
		  data: {
				last: $(this).attr('last'),
				type: $(this).attr('type')
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
	
	/******* jQuery UI *******/
	
	$("#tabs").tabs();
	
	$("#tabs").bind('tabsselect', function(event, ui){
		list = $('.updates');
		list.find('li').hide();
		showUpdatesFor($(ui.tab).attr('target'));
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

function showUpdatesFor(type){
	if(type == ''){type = 'all'}
	list = $('#'+type+' .updates');
	list.find('li').hide();
	switch(type){
		case 'user':
			list.find('.user').show();
			break;
		case 'group':
			list.find('.group').show();
			break;
		default:
			list.find('li').show();
	}
}

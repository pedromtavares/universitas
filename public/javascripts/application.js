$(function(){
	$("#tabs").tabs();
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
				$('#chosen-docs').append(target.attr('target'));
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
});


function highlight(obj,color, time){
  var original = obj.css('background');
  obj.animate({
    backgroundColor: color
  },time/2);

  obj.animate({
    backgroundColor: original
  },time/2);

}
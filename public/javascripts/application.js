jQuery(function(){
  $('form').live('submit', function(e) {
    $(this).append('Loading...');
  })
})

$(document).ready(function() {
	$("#edit_group_cancel").click(function() { 
		$('#edit_group').hide(); 
		$('#group_info').show();
	});
	$("a#edit_student_cancel").click(function() { 
		id = $(this).attr("data");
		$("#edit_student_"+id).hide();
		$("#student_info_"+id).show();

	});
});
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
});
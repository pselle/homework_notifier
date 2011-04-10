jQuery(function(){
  $('form').live('submit', function(e) {
    $(this).append('Loading...');
  })
})
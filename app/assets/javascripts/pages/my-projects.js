$(document).ready(function(){
	$('#modal-embed .launch-with input[type=radio]').on('change', function(){
		if($(this).val() == 'thumbnail'){
			$(this).parents('.tab-pane').removeClass('launch-text');
		}else{
			$(this).parents('.tab-pane').addClass('launch-text');
		}
	});
});
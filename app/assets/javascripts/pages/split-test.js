$(document).ready(function(){
	$('#split-test .variations_data .select').on('mouseenter', function(){
		$(this).siblings('.actions').show();
	});
	$('#split-test .variations_data .actions').on('mouseleave', function(){
		$(this).hide();
	});

	$('#split-test .variations_data .percent-slider').each(function(){
		$(this).slider({
			value: parseInt($(this).data('value')),
			slide: function( event, ui ) {
				$(ui.handle).parents('td').find('.percent').html(ui.value + '%');
			}
		});
	});
});
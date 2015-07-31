$(document).ready(function() {
	tabs();
});

function tabs(){
	$('.slidedown').hide();
	$('.tab').click(function(event) {
		var children = $(this).parent('.row').find('.slidedown');
		$(this).toggleClass('arrow');		
		children.slideToggle();		
		var childrenTop = children.offset().top;
		var body = $("html, body");
		body.animate({scrollTop: childrenTop}, 300, 'swing', function() { 
		});
	});
}
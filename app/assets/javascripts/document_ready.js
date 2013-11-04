jQuery(function() {
	$('.fancybox').fancybox();
	$(".fancybox-media").fancybox({
		openEffect : 'none',
		closeEffect : 'none',
		aspectRatio : 'true',
		width : 960,
		helpers : {
			media : {
				youtube : {
					params : {
						autoplay : 0
					}
				}
			}
		}
	});
});
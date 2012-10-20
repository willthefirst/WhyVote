


	var VOTE = {
		init: function() {
			VOTE.chooseCandidate();
		},

		chooseCandidate: function() {
			$('.candidate').on('click', function() {
				console.log(this);
				this.css('display','none');
			});
		}
	};

	console.log('asd');

$(function() {
	VOTE.init();
});
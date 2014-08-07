var colors = [
	d3.rgb('#676766').darker(0.15),
	d3.rgb('#47acb1').darker(0.15),
	d3.rgb('#efbc20').darker(0.15),
	d3.rgb('#f26522').darker(0.15)
];

var rainbow = function(numOfSteps, step) {
	var fullColors = [];

	_(colors).each(function(color, i) {
		var round = i % 2 !== 1 ? 'ceil' : 'floor';
		var alternates = Math[round](numOfSteps / colors.length);
		color = d3.rgb(color);

		for (var index = 0; index <= alternates; index++) {
			fullColors.push(color.brighter(index / alternates * 0.85));
		}
	});

	// one more to prevent errors
	fullColors.push(fullColors[0]);

	return fullColors[step];
};

var staggeredRainbow = function(numOfSteps, step) {
	if (numOfSteps % 2 === 1 && step === Math.ceil(numOfSteps / 2))  {
		step = 0;
	} else if (step % 2 === 1) {
		step = numOfSteps - step;
	}
	return rainbow(numOfSteps, step);
};

var visualizations = [];

d3.selection.prototype.moveToFront = function() {
	return this.each(function(){
		this.parentNode.appendChild(this);
	});
};

(function() {
	var visualize = function() {
		d3.json('data/comments-over-time.json', function(error, graph) {
			var width = $(window).width();
			var height = $(window).height();
			var months = [
				'January',
				'February',
				'March',
				'April',
				'May',
				'June',
				'July',
				'August',
				'September',
				'October',
				'November',
				'December'
			];

			var stack = d3.layout.stack()
				.offset('wiggle')
				.y(function(d) {
					return d.y / height;
				})
				.values(function(d) {
					return d.values;
				});

			var increment = width / graph.dates.length;

			d3.select('#commentsOverTime svg').remove();

			var svg = d3.select('#commentsOverTime').append('svg')
				.attr('width', width)
				.attr('height', height);

			var markers = svg.selectAll('g.marker')
				.data(graph.dates)
				.enter().append('g');

			markers.append('rect')
				.attr('fill', '#d1dbd3')
				.attr('opacity', '0.7')
				.attr('x', function(d, i) {
					return (i * increment);
				})
				.attr('y', 0)
				.attr('width', 1)
				.attr('height', height);

			markers.append('text')
				.attr('fill', '#a5b1a8')
				.attr('font-size', '12px')
				.attr('x', function(d, i) {
					return (i * increment) + 20;
				})
				.attr('y', height)
				.attr('transform', function(d, i) {
					var x = (i * increment) + 15;
					var y = height;
					return 'rotate(-90 ' + x + ' ' + y + ')';
				})
				.style('font-size', 15)
				.text(function(d, i) {
					var date = new Date(d);
					date.setMonth(date.getMonth() - 1);
					var month = date.getMonth();
					if (i === 0 || month === 0) {
						return date.getFullYear();
					}
				});

			var x = d3.scale.linear()
				.domain([0, graph.dates.length - 1])
				.range([0, width]);

			var yMax = 1.1;

			var y = d3.scale.linear()
				.domain([0, 1875 / height])
				.range([height -50, 0]);

			var area = d3.svg.area()
				.x(function(d) {
					return x(d.x);
				})
				.y0(function(d) {
					return y(d.y0);
				})
				.y1(function(d) {
					return y(d.y + d.y0);
				});

			var data = _(graph.comments).map(function(child) {
				return child.length;
			});

			var currentDate = function(mouseX) {
				var startDate = (new Date(graph.startDate)).getTime();
				var endDate = (new Date(graph.endDate));
				endDate = new Date(endDate.getFullYear(), endDate.getMonth() + 1);
				endDate = endDate.getTime();
				var range = endDate - startDate;
				var mousePos = mouseX / width;
				var rawDate = (mousePos * range) + startDate;
				var date = new Date(rawDate);

				return new Date(date.getFullYear(), date.getMonth());
			};

			var path = svg.selectAll('path')
				.data(stack(graph.comments))
				.enter().append('path')
				.attr('d', function(d) {
					return area(d.values);
				})
				.style('fill', function(d) {
					return staggeredRainbow(graph.comments.length, _(graph.comments).indexOf(d));
				})
				.on('mouseover', function(d, index) {
					d3.select(this).attr('opacity', 0.5);
				})
				.on('mousemove', function(d) {
					var mouse = d3.mouse(this);

					title.attr('transform', function(d) {
						if (mouse[0] > 0 && mouse[1] > 0) {
							return 'translate('
								+ (mouse[0] - 175)
								+ ' '
								+ mouse[1]
								+ ')';

						} else {
							return d3.select(this).attr('transform');
						}
					});

					var color = staggeredRainbow(graph.comments.length, _(graph.comments).indexOf(d));

					name.text(function() {
						var userData = _(graph.comments).findWhere({username: d.username});
						var date = currentDate(mouse[0]);
						var data = _(userData.values).findWhere({date: date.toISOString()});
						return d.username;
					})
					.attr('fill', color);

					var userData = _(graph.comments).findWhere({username: d.username});
					var mouseDate = currentDate(mouse[0]);
					var data = _(userData.values).findWhere({date: mouseDate.toISOString()});

					comments.text(function() {
						return data.count + ' comments';
					});

					date.text(function() {
						return months[mouseDate.getMonth()] + ' ' + mouseDate.getFullYear();
					});
				})
				.on('mouseout', function(d, index, what) {
					d3.select(this).attr('opacity', 1);
					title.attr('transform', 'translate(-200 -200)');
				});

			var title = svg.append('g')
				.attr('transform', 'translate(-200 -200)');

			var rect = title.append('rect')
				.attr('fill', '#fff')
				.attr('width', 150)
				.attr('height', 70);

			var name = title.append('text')
				.attr('fill', '#000')
				.attr('font-size', '15px')
				.attr('y', 20)
				.attr('x', 10)
				.style('font-size', 15);

			var date = title.append('text')
				.attr('fill', '#000')
				.attr('font-size', '15px')
				.attr('y', 40)
				.attr('x', 10)
				.style('font-size', 15);

			var comments = title.append('text')
				.attr('fill', '#000')
				.attr('font-size', '15px')
				.attr('y', 60)
				.attr('x', 10)
				.style('font-size', 15);
		});
	};

	visualize();
	$(window).on('resize', visualize);
})();

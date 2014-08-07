(function() {
	var force = d3.layout.force()
		.charge(500);

	var thumbWidth = 110;
	var thumbHeight = thumbWidth * 0.75;


	var svg = d3.select('#commentLinks').append('svg');

	var resize = function() {
		var width = $(window).width();
		var height = $(window).height();

		svg
			.attr('width', width)
			.attr('height', height);

		force
			.stop()
			.size([width, height])
			.linkDistance(function(d) {
				var value = 500 - d.value;
				return (Math.min(width, height) + value) * 0.3;
			})
			.start();
	};

	$(window).on('resize', resize);

	d3.json('data/comment-links.json', function(error, graph) {

		graph.nodes = _(graph.nodes).each(function(node, i) {
			node.color = rainbow(graph.nodes.length, i + 1);
		});

		// background images
		var defs = svg.append('svg:defs');

		_(graph.nodes).each(function(node) {
			defs.append('svg:pattern')
				.attr('id', node.login + 'comment')
				.attr('width', thumbWidth)
				.attr('height', thumbHeight)
				.attr('x', -(thumbWidth / 2))
				.attr('y', -(thumbHeight / 2))
				.attr('patternUnits', 'userSpaceOnUse')
				.append('svg:image')
				.attr('width', thumbWidth)
				.attr('height', thumbHeight)
				.attr('xlink:href', node.icon);
		});

		// setup
		force
			.nodes(graph.nodes)
			.links(graph.links);

		resize();

		// link lines
		var link = svg.selectAll('.link')
			.data(graph.links)
			.enter()
			.append('line')
			.attr('class', 'link')
			.attr('stroke-opacity', 0.1)
			.attr('stroke-width', function(d) {
				return d.value * 0.08;
			})
			.attr('stroke', function(d) {
				return d.source.color;
			});

		// nodes
		var node = svg.selectAll('.node')
			.data(graph.nodes)
			.enter()
			.append('g')
			.attr('class', 'node')
			.call(force.drag)
			.each(function(d) {
				var $this = d3.select(this);

				$this.append('circle')
					.attr('r', (thumbHeight / 2) - 2)
					.attr('stroke-width', function(d) {
						return Math.sqrt(d.commentCount) * 0.5;
					})
					.attr('stroke', function(d) {
						return d.color;
					});

				$this.append('circle')
					.attr('r', thumbHeight / 2)
					.attr('fill', function(d) {
						return 'url(#' + d.login + 'comment)';
					})
					.on('mouseover', function() {
						$this.moveToFront();
						var userLinks = link.filter(function(l) {
							return l.source === d;
						});
						userLinks.attr('stroke-opacity', 1);
						var otherLinks = link.filter(function(l) {
							return l.source !== d;
						});
						otherLinks.attr('stroke-opacity', 0);
					})
					.on('mouseout', function(d) {
						link.attr('stroke-opacity', 0.1);
					});

				$this.append('text')
					.attr('fill', '#444')
					.attr('dx', 0)
					.attr('dy', (thumbHeight / 2) + 25)
					.attr('width', 150)
					.text(function(d) {
						return d.name;
					})
					.each(function() {

						var width = this.getBBox().width + 20;

						d3.select(this.parentNode)
							.insert('rect', 'text')
							.attr('x', -(width / 2))
							.attr('y', (thumbHeight / 2) + 10)
							.attr('height', 23)
							.attr('width', width)
							.attr('fill', '#fff');
					});
			});

		// tick
		force.on('tick', function() {
			link.attr('x1', function(d) { return d.source.x; })
				.attr('y1', function(d) { return d.source.y; })
				.attr('x2', function(d) { return d.target.x; })
				.attr('y2', function(d) { return d.target.y; });

			node.attr('transform', function(d) { return 'translate(' + d.x + ',' + d.y + ')'; });
		});
	});
})();

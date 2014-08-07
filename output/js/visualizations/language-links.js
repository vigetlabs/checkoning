(function() {
	var force = d3.layout.force()
		.distance(180)
		.charge(function(d) {
			if (d.language) {
				return -d.weight * 500;
			} else {
				return -1500;
			}
		})
		.gravity(0.8);

	var thumbWidth = 50;
	var thumbHeight = thumbWidth * 0.75;

	d3.select('#languageLinks svg').remove();

	var svg = d3.select('#languageLinks').append('svg');

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
				var value = 35 - Math.sqrt(d.value);
				return (Math.min(width, height) * 0.1) + value * 4;
			})
			.start();
	};

	$(window).on('resize', resize);

	d3.json('data/language-links.json', function(error, graph) {

		var languages = _(graph.nodes).filter(function(item) {
			return item.language !== undefined;
		});

		_(languages).each(function(node, i) {
			node.color = rainbow(languages.length, i + 1);
		});

		var users = _(graph.nodes).filter(function(item) {
			return item.language == undefined;
		});

		_(users).each(function(node, i) {
			node.color = rainbow(users.length, i + 1);
		});

		// background images
		var defs = svg.append('svg:defs');

		_(graph.nodes).each(function(node) {
			defs.append('svg:pattern')
				.attr('id', node.login + 'language')
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
				return Math.sqrt(d.value) * 0.7;
			})
			.attr('stroke', function(d) {
				return d.source.color;
			});

		// nodes
		var node = svg.selectAll('.node')
			.data(graph.nodes)
			.enter()
			.append('g')
			.call(force.drag);

		var languageNodes = node.filter(function(d) {
			return d.language != undefined;
		});

		languageNodes.each(function(d, i) {
			var $this = d3.select(this);
			$this.attr('class', 'node language-node')
				.on('mouseover', function() {
					$this.moveToFront();
					var targetLinks = link.filter(function(l) {
						return l.target === d;
					});
					targetLinks.attr('stroke-opacity', 1);
					var otherLinks = link.filter(function(l) {
						return l.target !== d;
					});
					otherLinks.attr('stroke-opacity', 0);
				})
				.on('mouseout', function(d) {
					link.attr('stroke-opacity', 0.1);
				})
				.append('circle')
				.attr('r', thumbHeight * (d.weight / 10) + 10)
				.attr('fill', rainbow(languages.length, i + 1).darker(0.2));

			$this.append('text')
				.attr('fill', '#fff')
				.attr('text-anchor', 'middle')
				.attr('dy', '.3em')
				.attr('dx', 0)
				.style('font-size', function(d) {
					var size = (d.weight * 1.5) + 5;
					return size + 'px';
				})
				.text(function(d) { return d.language; });
		});

		var userNodes = node.filter(function(d) {
			return d.language == undefined;
		});

		userNodes.each(function(d, i) {
			var $this = d3.select(this);

			$this.on('mouseover', function() {
				$this.moveToFront();
				var sourceLinks = link.filter(function(l) {
					return l.source === d;
				});
				sourceLinks
					.attr('stroke-opacity', 1)
					.attr('stroke', function(d) {
						return d.target.color;
					});

				var otherLinks = link.filter(function(l) {
					return l.source !== d;
				});

				otherLinks.attr('stroke-opacity', 0);
			})
			.on('mouseout', function(d) {
				link
					.attr('stroke-opacity', 0.1)
					.attr('stroke', function(d) {
						return d.source.color;
					});
			});

			$this.attr('class', 'node user-node')
				.append('circle')
				.attr('stroke-width', function(d) {
					var links = _(graph.links).chain().map(function(link) {
						if (link.source === d) {
							return link.target;
						}
					}).compact().uniq().value();
					return links.length;
				})
				.attr('stroke', function(d) {
					return d.color;
				})
				.attr('r', thumbHeight / 2);

			$this.append('circle')
				.attr('r', thumbHeight / 2)
				.attr('fill', 'url(#' + d.login + 'language)');

			var rect = $this.append('rect')
				.attr('y', (thumbHeight / 2) + 10)
				.attr('height', 23)
				.attr('fill', '#fff');

			var text = $this.append('text')
				.attr('fill', '#444')
				.attr('text-anchor', 'middle')
				.attr('dx', 0)
				.attr('dy', (thumbHeight / 2) + 25)
				.attr('width', 150)
				.text(function(d) { return d.name; });

			var width = this.getBBox().width + 20;
			rect
				.attr('x', -(width / 2))
				.attr('width', width);
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

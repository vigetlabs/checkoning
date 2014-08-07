(function() {
	var visualize = function() {
		d3.json('data/common-words.json', function(error, root) {
			var width = $(window).width();
			var height = $(window).height();

			var r = Math.min(width, height),
					format = d3.format(',d'),
					fill = d3.scale.category20c();

			var bubble = d3.layout.pack()
					.sort(null)
					.size([width, height])
					.padding(1.5);

			var maxWordLength = _(root.children).max(function(word) {
				return word.name.length;
			}).name.length;

			d3.select('#commonWords svg').remove();

			var vis = d3.select('#commonWords').append('svg')
					.attr('width', width)
					.attr('height', height)
					.attr('class', 'bubble');

				var node = vis.selectAll('g.node')
					.data(bubble.nodes(classes(root))
					.filter(function(d) { return !d.children; }))
					.enter().append('g')
					.attr('class', 'node')
					.attr('transform', function(d) { return 'translate(' + d.x + ',' + d.y + ')'; });

				node.append('title')
					.text(function(d) { return d.className + ': ' + format(d.value); });

				node.each(function(node, i) {
					node.color = rainbow(
						(maxWordLength * maxWordLength) + 11,
						(node.className.length * node.className.length) + 11
					).darker(0.3);
				});

				node.append('circle')
					.attr('r', function(d) { return d.r; })
					.style('fill', function(d) {
							return d.color;
					});

				node.append('text')
					.style('font-size', function(d) {
						var size = (Math.sqrt(d.value) * 0.8) - (d.className.length - 3);
						if (size <= 1) {
							size = 1;
						};
						return size + 'px';
					})
					.attr('fill', '#fff')
					.attr('text-anchor', 'middle')
					.attr('dy', '.3em')
					.text(function(d) { return d.className; });

			// Returns a flattened hierarchy containing all leaf nodes under the root.
			function classes(root) {
				var classes = [];

				function recurse(name, node) {
					if (node.children) node.children.forEach(function(child) { recurse(node.name, child); });
					else classes.push({packageName: name, className: node.name, value: node.size});
				}

				recurse(null, root);
				return {children: classes};
			}
		});
	};

	visualize();
	$(window).on('resize', visualize);

})();

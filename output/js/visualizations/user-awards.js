(function() {

	var $container = $('#userAwards');

	$.getJSON('data/user-awards.json', function(data) {
		var $dl = $('<dl></dl>');

		$('<dt>Most comments left:</dt>').appendTo($dl);
		$('<dd><b>' + data.mostCommentsLeft.name+ '</b> with ' + data.mostCommentsLeft.commentsLeft+ '</dd>').appendTo($dl);

		$('<dt>Most comments recieved:</dt>').appendTo($dl);
		$('<dd><b>' + data.mostCommentsRecieved.name+ '</b> with ' + data.mostCommentsRecieved.commentsRecieved + '</dd>').appendTo($dl);

		$('<dt>Most swearing:</dt>').appendTo($dl);
		$('<dd><b>' + data.mostSwears.name + '</b> at ' + data.mostSwears.swearsPerComment + ' swears per comment</dd>').appendTo($dl);

		$('<dt>Most code examples:</dt>').appendTo($dl);
		$('<dd><b>' + data.mostExamples.name + '</b> at ' + data.mostExamples.examplesPerComment + ' examples per comment</dd>').appendTo($dl);

		$('<dt>Most gifs:</dt>').appendTo($dl);
		$('<dd><b>' + data.mostGifs.name + '</b> at ' + data.mostGifs.gifsPerComment + ' gifs per comment</dd>').appendTo($dl);

		$('<dt>Most emoji:</dt>').appendTo($dl);
		$('<dd><b>' + data.mostEmojis.name + '</b> at ' + data.mostEmojis.emojisPerComment + ' emoji per comment</dd>').appendTo($dl);

		$('<dt>Top 10 emojis:</dt>').appendTo($dl);
		var emojis = [];
		_(data.mostUsedEmoji).each(function(item) {
			if (item.code !== '::') {
				emojis.push('<img src="emoji/' + item.code.replace(/:/g, '') + '.png" height="32" width="32">');
			}
		});
		emojis = emojis.slice(0, 10);
		$('<dd>' + emojis.join(' ') + '</dd>').appendTo($dl);

		$('<dt>Longest comment:</dt>').appendTo($dl);
		$('<dd><b>' + data.longestComment.name + '</b> with:<br>' + marked(data.longestComment.comment) + '<br> (' + data.longestComment.wordCount + ' words)</dd>').appendTo($dl);

		$dl.appendTo($container);
	});

})();

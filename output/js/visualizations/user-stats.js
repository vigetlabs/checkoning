(function() {

	var $container = $('#userStats');

	$.getJSON('data/user-stats.json', function(data) {
		_(data).each(function(user) {
			var $div = $('<div></div>');

			$('<img src="' + user.icon + '">').appendTo($div);
			$('<h2>' + user.name + '</h2>').appendTo($div);

			var $dl1 = $('<dl></dl>');
			var $dl2 = $('<dl></dl>');
			$('<dt>PRs created:</dt>').appendTo($dl1);
			$('<dd>' + user.prsCreated + '</dd>').appendTo($dl1);
			$('<dt>Average PR duration:</dt>').appendTo($dl1);
			var time = user.prDuration.h + ' hours';
			if (user.prDuration.d > 0) {
				time = user.prDuration.d + ' days, ' + time;
			}
			$('<dd>' + time + '</dd>').appendTo($dl1);
			$('<dt>Average PR creation time:</dt>').appendTo($dl1);
			$('<dd>' + user.prCreation + '</dd>').appendTo($dl1);
			$('<dt>Average comment time:</dt>').appendTo($dl1);
			$('<dd>' + user.commentTime + '</dd>').appendTo($dl1);
			$('<dt>Average comment length:</dt>').appendTo($dl1);
			$('<dd>' + user.commentLength + ' words</dd>').appendTo($dl1);

			$('<dt>Comments left:</dt>').appendTo($dl2);
			$('<dd>' + user.commentsLeft + '</dd>').appendTo($dl2);
			$('<dt>Comments recieved:</dt>').appendTo($dl2);
			$('<dd>' + user.commentsRecieved + '</dd>').appendTo($dl2);
			$('<dt>Favorite language:</dt>').appendTo($dl2);
			$('<dd><b>' + user.favoriteLanguage + '</b> at ' + user.favoriteLanguageCount + ' comments</dd>').appendTo($dl2);
			$('<dt>BFF:</dt>').appendTo($dl2);
			$('<dd>' + user.name + ' left ' + user.bffCount + ' comments for <b>' + user.bff + '</b></dd>').appendTo($dl2);
			$('<dt>Admirer:</dt>').appendTo($dl2);
			$('<dd><b>' + user.admirer + '</b> left ' + user.admirerCount + ' comments for ' + user.name + '</dd>').appendTo($dl2);

			$dl1.appendTo($div);
			$dl2.appendTo($div);
			$div.appendTo($container);
		});
	});

})();

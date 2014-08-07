_ = require('underscore')

module.exports = (user)->
	totalCommentTime = _(user.commentsLeft).reduce (memo, comment) ->
		creation = Date.parse(comment.created_at)
		creation = new Date(creation)
		memo + creation.getHours()
	, 0

	average = totalCommentTime / user.commentsLeft.length
	average -= 2 if user.office is 'boulder'
	average = Math.floor(average)

	if average > 12
		average = average - 12 + ' p.m.'
	else
		average += ' a.m.'

	average = '12 a.m.' if average == '0 a.m.'

	commentTime: average

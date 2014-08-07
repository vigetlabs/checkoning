_ = require('underscore')

countWords = (str) ->
  regex = /\s+/gi
  str.trim().replace(regex, ' ').split(' ').length

module.exports = (user)->
	totalCommentLength = _(user.commentsLeft).reduce (memo, comment) ->
		memo + countWords(comment.body)
	, 0

	average = Math.floor(totalCommentLength / user.commentsLeft.length)

	commentLength: average

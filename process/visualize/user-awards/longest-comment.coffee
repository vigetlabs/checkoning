_ = require('underscore')

countWords = (str) ->
  regex = /\s+/gi
  str.trim().replace(regex, ' ').split(' ').length

module.exports = (data)->
	longestComment = _(data.processed.comments).max (comment)->
		countWords(comment.body)

	user = _(data.processed.team).findWhere(login: longestComment.user.login)

	longestComment:
		name: user.name
		comment: longestComment.body
		wordCount: countWords(longestComment.body)

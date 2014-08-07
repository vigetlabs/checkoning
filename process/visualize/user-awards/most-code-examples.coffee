_ = require('underscore')

module.exports = (data)->
	exampleRegex = /```/g

	users = _(data.processed.team).map (user)->
		login: user.login
		name: user.name
		exampleCount: 0
		commentCount: user.commentsLeft.length

	_(data.processed.comments).each (comment)->
		examples = comment.body.match(exampleRegex)

		if examples? and examples.length > 0
			user = _(users).findWhere(login: comment.user.login)
			user.exampleCount += examples.length / 2

	user = _(users).max (user)->
		user.exampleCount / user.commentCount

	mostExamples:
		name: user.name
		exampleCount: user.exampleCount
		commentCount: user.commentCount
		examplesPerComment: Math.round(user.exampleCount / user.commentCount * 10000) / 10000

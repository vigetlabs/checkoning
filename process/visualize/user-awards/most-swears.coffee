_ = require('underscore')

module.exports = (data)->
	swearRegex = /(fuck|shit|damn|dammit|crap)/g

	users = _(data.processed.team).map (user)->
		login: user.login
		name: user.name
		swearCount: 0
		commentCount: user.commentsLeft.length

	_(data.processed.comments).each (comment)->
		swears = comment.body.match(swearRegex)

		if swears? and swears.length > 0
			user = _(users).findWhere(login: comment.user.login)
			user.swearCount += swears.length

	user = _(users).max (user)->
		user.swearCount / user.commentCount

	mostSwears:
		name: user.name
		swearCount: user.swearCount
		commentCount: user.commentCount
		swearsPerComment: Math.round(user.swearCount / user.commentCount * 10000) / 10000

_ = require('underscore')

module.exports = (data)->
	emojiRegex = /:.*?:/g

	users = _(data.processed.team).map (user)->
		login: user.login
		name: user.name
		emojiCount: 0
		commentCount: user.commentsLeft.length

	_(data.processed.comments).each (comment)->
		emojis = comment.body.match(emojiRegex)

		if emojis? and emojis.length > 0
			user = _(users).findWhere(login: comment.user.login)
			user.emojiCount += emojis.length / 2

	user = _(users).max (user)->
		user.emojiCount / user.commentCount

	mostEmojis:
		name: user.name
		emojiCount: user.emojiCount
		commentCount: user.commentCount
		emojisPerComment: Math.round(user.emojiCount / user.commentCount * 10000) / 10000

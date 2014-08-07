_ = require('underscore')

module.exports = (data)->
	gifRegex = /\.gif/g

	users = _(data.processed.team).map (user)->
		login: user.login
		name: user.name
		gifCount: 0
		commentCount: user.commentsLeft.length

	_(data.processed.comments).each (comment)->
		gifs = comment.body.match(gifRegex)

		if gifs? and gifs.length > 0
			user = _(users).findWhere(login: comment.user.login)
			user.gifCount += gifs.length / 2

	user = _(users).max (user)->
		user.gifCount / user.commentCount

	mostGifs:
		name: user.name
		gifCount: user.gifCount
		commentCount: user.commentCount
		gifsPerComment: Math.round(user.gifCount / user.commentCount * 10000) / 10000

_ = require('underscore')

module.exports = (data)->
	user = _(data.processed.team).max (user)->
		user.commentsLeft.length

	mostCommentsLeft:
		name: user.name
		commentsLeft: user.commentsLeft.length

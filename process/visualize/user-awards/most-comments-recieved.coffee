_ = require('underscore')

module.exports = (data)->
	user = _(data.processed.team).max (user)->
		user.commentsRecieved.length

	mostCommentsRecieved:
		name: user.name
		commentsRecieved: user.commentsRecieved.length

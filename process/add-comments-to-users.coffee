RSVP	= require('rsvp')
_	 = require('underscore')

getCommentsLeft = (user, data)->
	comments = _(data.raw.comments).filter (comment)->
	# comments = _(data.raw.comments.slice(0, 50)).filter (comment)->
		user.login == comment.user.login and
		user.login != _(data.raw.prs).findWhere(url: comment.pull_request_url)

getCommentsRecieved = (user, data)->
	comments = _(data.raw.comments).filter (comment)->
	# comments = _(data.raw.comments.slice(0, 50)).filter (comment)->
		user.login != comment.user.login and
		user.login == _(data.raw.prs).findWhere(url: comment.pull_request_url).user.login

module.exports = (data)->
	new RSVP.Promise (resolve)->
		console.log('...adding comments to users')

		for user in data.processed.team
			user.commentsLeft = getCommentsLeft(user, data)
			user.commentsRecieved = getCommentsRecieved(user, data)

		resolve(data)

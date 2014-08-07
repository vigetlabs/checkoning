RSVP	= require('rsvp')
_	 = require('underscore')

module.exports = (data)->
	new RSVP.Promise (resolve)->
		console.log('...removing non-team comments')

		data.processed.comments = []

		for comment in data.raw.comments
			for member in data.raw.team
				if member.login == comment.user.login
					data.processed.comments.push comment

		resolve(data)

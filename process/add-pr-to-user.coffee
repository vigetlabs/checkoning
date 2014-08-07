RSVP	= require('rsvp')
_	 = require('underscore')

module.exports = (data)->
	new RSVP.Promise (resolve)->
		console.log('...adding prs to users')

		for user in data.processed.team
			user.prsCreated = []

		for pr in data.raw.prs
			user = _(data.processed.team).findWhere(login: pr.user.login)
			user.prsCreated.push(pr) if user?

		resolve(data)

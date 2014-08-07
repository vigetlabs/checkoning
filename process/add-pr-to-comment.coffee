RSVP	= require('rsvp')
_	 = require('underscore')

module.exports = (data)->
	new RSVP.Promise (resolve)->
		console.log('...adding targets to comments')

		for comment in data.processed.comments
			comment.pr = _(data.raw.prs).findWhere(url: comment.pull_request_url)

		resolve(data)

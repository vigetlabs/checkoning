RSVP  = require('rsvp')
count = require('../util/count')

module.exports = (data)->
	new RSVP.Promise (resolve)->
		console.log '...getting comments'
		commentPromises = (require('./get_comments')(data, pr) for pr in data.prs)

		RSVP.all(commentPromises).then ()->
			console.log "   comments: #{data.comments.length}"
			resolve(data)

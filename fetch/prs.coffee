RSVP	= require('rsvp')
count = require('../util/count')

module.exports = (data)->
	new RSVP.Promise (resolve)->
		console.log '...getting prs'
		prPromises = (require('./get_prs_from_repo')(data, repo) for repo in data.repos)

		RSVP.all(prPromises).then ()->
			count(data, 'prs')
			resolve(data)

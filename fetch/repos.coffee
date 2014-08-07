RSVP	= require('rsvp')
count = require('../util/count')

module.exports = (data)->
	new RSVP.Promise (resolve)->
		console.log '...getting repos'
		repoPromises = (require('./get_repo')(data, i) for i in [1..10])

		RSVP.all(repoPromises).then ()->
			count(data, 'repos')
			resolve(data)

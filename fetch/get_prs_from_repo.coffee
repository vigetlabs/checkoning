RSVP = require('rsvp')

module.exports = (data, repo)->
	new RSVP.Promise (resolve)->
		prPromises = (require('./get_pr')(data, repo, i) for i in [1..10])

		RSVP.all(prPromises).then ()->
			resolve(data)

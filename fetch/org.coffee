RSVP = require('rsvp')

module.exports = (data)->
	new RSVP.Promise (resolve)->
		data.org = data.client.org(data.credentials.organization)
		resolve(data)

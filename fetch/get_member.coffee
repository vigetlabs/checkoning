RSVP = require('rsvp')

module.exports = (data, username)->
	new RSVP.Promise (resolve)->
		user = data.client.get "/users/#{username}", (err, status, user)->

			data.team = data.team || []
			data.team = data.team.concat(user)
			resolve()

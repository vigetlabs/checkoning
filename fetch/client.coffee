RSVP	 = require('rsvp')
github = require('octonode')

module.exports = (data)->
	new RSVP.Promise (resolve)->
		creds = data.credentials
		console.log "\n...getting client\n
   username:     #{creds.username}\n
   password:     #{creds.password.replace(/./g, '*')}\n
   organization: #{creds.organization}\n
   team:         #{creds.team}\n
"

		data.client = github.client
			username: creds.username
			password: creds.password

		data.client.limit (error, left, max)->
			if error? then console.log(error.message)
			console.log "   requests until limit: #{left}"
			resolve(data)

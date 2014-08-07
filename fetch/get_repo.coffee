RSVP = require('rsvp')

module.exports = (data, i)->
	new RSVP.Promise (resolve)->
		data.org.repos
			page: i
			per_page: 100
			type: 'private'
		, (error, repos)->
			if error? then console.log(error.message)
			data.repos = data.repos || []

			data.repos = data.repos.concat(repos)
			resolve()

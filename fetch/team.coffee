RSVP = require('rsvp')
_    = require('underscore')

module.exports = (data)->
	new RSVP.Promise (resolve)->
		console.log '...getting team'

		data.client.get "/orgs/#{data.credentials.organization}/teams", per_page: 100, (error, status, teams)->
			if error? then console.log(error.message)
			team = _(teams).findWhere(slug: data.credentials.team)

			console.log '   found team.'
			console.log '...getting members'

			data.client.get "/teams/#{team.id}/members", (error, status, members)->

				console.log '   found members.'
				console.log '...getting each member'
				memberPromises = (require('./get_member')(data, member.login) for member in members)

				RSVP.all(memberPromises).then ()->
					console.log "   got #{data.team.length} members."
					resolve(data) if members?

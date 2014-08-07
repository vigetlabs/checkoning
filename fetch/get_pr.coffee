RSVP = require('rsvp')

module.exports = (data, repo, i)->
	new RSVP.Promise (resolve)->
		repo = data.client.repo(repo.full_name)
		repo.prs
			page: i
			per_page: 100
			state: 'closed'
		, (error, prs)->
			if error? then console.log(error.message)

			data.prs = data.prs || []
			data.prs = data.prs.concat(prs)
			resolve()

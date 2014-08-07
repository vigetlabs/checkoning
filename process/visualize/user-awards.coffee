fs	 = require('fs')
RSVP = require('rsvp')
_		 = require('underscore')

module.exports = (data)->
	new RSVP.Promise (resolve)->
		console.log('...visualizing user awards')

		awards = {}

		_(awards).extend(
			require('./user-awards/most-comments-left')(data)
			require('./user-awards/most-comments-recieved')(data)
			require('./user-awards/longest-comment')(data)
			require('./user-awards/most-swears')(data)
			require('./user-awards/most-code-examples')(data)
			require('./user-awards/most-gifs')(data)
			require('./user-awards/most-emoji')(data)
			require('./user-awards/most-used-emoji')(data)
		)

		fs.writeFile './output/data/user-awards.json', JSON.stringify(awards, null, '\t'), (error)->
			if error? then console.log(error)
			console.log '   saved user awards!'
			resolve(data)

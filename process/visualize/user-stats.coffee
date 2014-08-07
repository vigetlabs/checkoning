fs	 = require('fs')
RSVP = require('rsvp')
_		 = require('underscore')

module.exports = (data)->
	new RSVP.Promise (resolve)->
		console.log('...visualizing user stats')

		users = _(data.processed.team).map (user)->
			userData =
        icon             : user.icon
        name             : user.name
        commentsLeft     : user.commentsLeft.length
        commentsRecieved : user.commentsRecieved.length

			_(userData).extend(
        require('./user-stats/prs-created')(user, data.raw.prs),
        require('./user-stats/language')(user),
        require('./user-stats/bff')(user, data.processed.team),
        require('./user-stats/admirer')(user, data.processed.team),
        require('./user-stats/pr-duration')(user),
        require('./user-stats/pr-creation')(user),
        require('./user-stats/comment-time')(user),
        require('./user-stats/comment-length')(user)
			)

		fs.writeFile './output/data/user-stats.json', JSON.stringify(users, null, '\t'), (error)->
			if error? then console.log(error)
			console.log '   saved user stats!'
			resolve(data)

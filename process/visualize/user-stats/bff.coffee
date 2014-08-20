_ = require('underscore')

module.exports = (user, users)->
	bffs = {}
	bff = ''
	bffCount = 0

	for comment in user.commentsLeft
		if bffs[comment.pr.user.login]? and _(users).findWhere(login: comment.pr.user.login)?
			bffs[comment.pr.user.login]++
		else
			bffs[comment.pr.user.login] = 1

	for potentialBff, count of bffs
		if count > bffCount and potentialBff isnt user.login
			bffCount = count
			bff = potentialBff

	bff:			_(users).findWhere(login: bff)?.name
	bffCount: bffCount

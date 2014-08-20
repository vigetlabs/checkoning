_ = require('underscore')

module.exports = (user, users)->
	admirers = {}
	admirer = ''
	admirerCount = 0

	for comment in user.commentsRecieved
		if admirers[comment.user.login]?
			admirers[comment.user.login]++
		else
			admirers[comment.user.login] = 1

	for potentialAdmirer, count of admirers
		if count > admirerCount and admirer isnt user.login
			admirerCount = count
			admirer = potentialAdmirer

	admirer:      _(users).findWhere(login: admirer)?.name
	admirerCount: admirerCount

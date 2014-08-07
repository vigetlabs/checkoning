_ = require('underscore')

module.exports = (user, prs)->
	prsCreated = _(prs).filter (pr)-> user.login == pr.user.login
	prsCreated: prsCreated.length

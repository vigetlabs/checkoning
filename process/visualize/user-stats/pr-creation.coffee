_ = require('underscore')

module.exports = (user)->
	totalCreationTime = _(user.prsCreated).reduce (memo, pr) ->
		creation = Date.parse(pr.created_at)
		creation = new Date(creation)
		memo + creation.getHours()
	, 0

	average = totalCreationTime / user.prsCreated.length
	average -= 2 if user.office is 'boulder'
	average = Math.floor(average)

	if average > 12
		average = average - 12 + ' p.m.'
	else
		average += ' a.m.'

	average = '12 a.m.' if average == '0 a.m.'

	prCreation: average

_ = require('underscore')

# https://gist.github.com/remino/1563878
convertMs = (ms)->
	s = Math.floor(ms / 1000)
	m = Math.floor(s / 60)
	s = s % 60
	h = Math.floor(m / 60)
	m = m % 60
	d = Math.floor(h / 24)
	h = h % 24

	d: d, h: h, m: m, s: s

module.exports = (user)->
	totalDuration = _(user.prsCreated).reduce (memo, pr) ->
		duration = Date.parse(pr.closed_at)- Date.parse(pr.created_at)
		memo + duration
	, 0

	prDuration: convertMs(totalDuration / user.prsCreated.length)

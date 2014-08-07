fs	   = require('fs')
RSVP   = require('rsvp')
_	     = require('underscore')

module.exports = (data)->
	new RSVP.Promise (resolve)->
		console.log('...visualizing comments over time')

		commentsOverTime = []

		_(data.processed.team).each (user)->
			commentsOverTime.push
				user: user.login
				values: []

		_(data.processed.comments).each (comment)->
			date = new Date(Date.parse(comment.created_at))
			date = new Date(date.getFullYear(), date.getMonth())

			user = _(commentsOverTime).findWhere user: comment.user.login

			if user?
				value = _(user.values).filter (value)-> value.date.toString() is date.toString()
				if value[0]?
					value[0].y++
					value[0].count++
				else
					user.values.push
						date: date
						y: 1
						count: 1

		allValues = _(commentsOverTime).reduce (values, user) -> user.values.concat values
		startDate = _(allValues).min((value)-> value.date).date
		endDate = _(allValues).max((value)-> value.date).date

		_(commentsOverTime).each (user)->
			for year in [startDate.getFullYear()..endDate.getFullYear()]
				isStartYear = year == startDate.getFullYear()
				isEndYear = year == endDate.getFullYear()

				for month in [0..11]
					isBeforeStartMonth = isStartYear and month < startDate.getMonth()
					isAfterEndMonth = isEndYear and month > endDate.getMonth()

					unless isBeforeStartMonth or isAfterEndMonth
						date = new Date(year, month)
						value = _(user.values).filter (value)-> value.date.toString() is date.toString()
						unless value[0]?
							user.values.push
								date: date
								y: 0
								count: 0

			user.values = _(user.values).sortBy (value)-> value.date.getTime()
			user.username = _(data.processed.team).findWhere(login: user.user).name

		dates = []
		for year in [startDate.getFullYear()..endDate.getFullYear()]
			isStartYear = year == startDate.getFullYear()
			isEndYear = year == endDate.getFullYear()

			for month in [0..11]
				isBeforeStartMonth = isStartYear and month < startDate.getMonth()
				isAfterEndMonth = isEndYear and month > endDate.getMonth()

				unless isBeforeStartMonth or isAfterEndMonth
					dates.push new Date(year, month)

		_(commentsOverTime).each (user)->
			_(user.values).each (value, i)->
				value.x = i

		commentsOverTime = _(commentsOverTime).sortBy (user)->
			_(data.processed.team).findWhere(login: user.user).commentsLeft.length

		overTimeData =
			comments: commentsOverTime
			startDate: startDate
			endDate: endDate
			dates: dates

		fs.writeFile './output/data/comments-over-time.json', JSON.stringify(overTimeData, null, '\t'), (error)->
			if error? then console.log(error)
			console.log '   saved comments over time!'
			resolve(data)

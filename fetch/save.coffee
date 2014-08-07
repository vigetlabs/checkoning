RSVP = require('rsvp')
fs = require('fs')

module.exports = (data)->
	new RSVP.Promise (resolve)->
		console.log '...saving'
		fs.writeFile './data/raw.json', JSON.stringify(data), (error)->
			if error? then console.log(error)
			console.log '   saved!'
			resolve(data)

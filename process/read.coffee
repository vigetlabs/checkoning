fs = require('fs')
RSVP	= require('rsvp')

module.exports = new RSVP.Promise (resolve)->
	resolve
		raw: JSON.parse(fs.readFileSync('./data/raw.json'))
		processed: {}

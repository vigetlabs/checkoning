RSVP   = require('rsvp')
fs     = require('fs')
prompt = require('prompt')
_      = require('underscore')

module.exports = new RSVP.Promise (resolve)->
	data = {}
	if _(process.argv).contains('--config')
		data.credentials = JSON.parse(fs.readFileSync('.config.json'))
		resolve(data)
	else
		prompt.get require('./config_credentials'), (err, result)->
			data.credentials = result
			resolve(data)

_ = require('underscore')

module.exports = (data, key)->
	data[key] = data[key].slice(0, 15) if _(process.argv).contains('--sample')
	console.log "   #{key}: #{data[key].length}"

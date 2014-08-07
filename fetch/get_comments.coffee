RSVP = require('rsvp')

module.exports = (data, pr)->
	new RSVP.Promise (resolve)->
		comment_url = pr._links.review_comments.href.replace('https://api.github.com', '')
		data.client.get comment_url, (error, status, comments)->
			if error? then console.log(error.message)

			data.comments = data.comments || []
			data.comments = data.comments.concat(comments)
			resolve()

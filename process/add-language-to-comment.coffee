RSVP	= require('rsvp')
_	 = require('underscore')

languageMap =
	rb:          'ruby'
	gemfile:     'config'
	gemspec:     'config'
	rakefile:    'config'
	lock:        'config'
	example:     'config'
	yml:         'config'
	'bin/setup': 'config'
	gitignore:   'config'
	htaccess:    'config'
	npmignore:   'config'
	procfile:    'config'
	markdown:    'text'
	md:          'text'
	txt:         'text'
	mustache:    'html'
	jsx:         'html'
	jst:         'html'
	erb:         'html'

module.exports = (data)->
	new RSVP.Promise (resolve)->
		console.log('...adding languages to comments')

		matchers =
			css: /\.(scss|sass)$/
			js: /\.(js\.erb)$/
			html: /\.(.erb|hbs|tpl)$/

		for comment in data.processed.comments
			basicMatch = comment.path.match(/\.[0-9a-z]+$/)

			if basicMatch?
				filetype = basicMatch[0].slice(1)
			else
				filetype = comment.path

			for type, regex of matchers
				matched = comment.path.match(regex)

				if matched?
					filetype = type
					break

			comment.filetype = filetype.toLowerCase()
			comment.language = (languageMap[comment.filetype] || comment.filetype).toUpperCase()

			data.processed.comments.push comment unless comment.language.length > 10

		resolve(data)

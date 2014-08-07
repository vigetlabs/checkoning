fs	   = require('fs')
RSVP   = require('rsvp')
_	     = require('underscore')
common = require('common-words')

module.exports = (data)->
	new RSVP.Promise (resolve)->
		console.log('...visualizing common words')

		commonWords = []
		words = {}

		patterns =
			block       : /```[\s\S]*?```/g
			code        : /`.*?`/g
			emoji       : /:.*?:/g
			meta        : /(\r|\n|\t)/g
			digits      : /(\d)/g
			common      : /(github|http|https)/g

		for comment in data.processed.comments
			text = comment.body.toLowerCase()
			for name, pattern of patterns
				text = text.replace(pattern, '')

			text = text.match(/[A-Za-z0-9_\']+/g)
			text = [] if text == null

			for word in text
				if word != ' ' and word.length > 3
					if words[word]
						words[word]++
					else
						words[word] = 1

		for name, size of words
			commonWords.push
				name: name
				size: size

		commonWords = _(commonWords).filter (word)->
			tooCommon = _(common).findWhere(word: word.name)?
			return word.size > commonWords.length * 0.02 and !tooCommon

		fs.writeFile './output/data/common-words.json', JSON.stringify(children: commonWords, null, '\t'), (error)->
			if error? then console.log(error)
			console.log '   saved common words!'
			resolve(data)

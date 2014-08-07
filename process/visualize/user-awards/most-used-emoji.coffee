_ = require('underscore')

module.exports = (data)->
	emojiRegex = /:[a-z]*?:/g

	first = {}
	second = {}

	emojiList = []

	_(data.processed.comments).each (comment)->
		emojis = comment.body.match(emojiRegex)

		if emojis?
			for code in emojis
				emoji = _(emojiList).findWhere(code: code)
				if emoji?
					emoji.uses++
				else
					emojiList.push
						code: code
						uses: 1

	emojiList = _(emojiList).sortBy (emoji)->
		emoji.uses

	mostUsedEmoji: emojiList.reverse()

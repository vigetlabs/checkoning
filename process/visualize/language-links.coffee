fs	 = require('fs')
RSVP = require('rsvp')
_	   = require('underscore')

module.exports = (data)->
	new RSVP.Promise (resolve)->
		console.log('...visualizing language links')

		nodes = data.processed.team.map (user)->
			login:	      user.login
			name:         user.name
			icon:	        user.icon
			commentCount: 0
			group:        1

		languageLinks =
			nodes: nodes
			links: []

		for comment in data.processed.comments
			if comment.language.length < 10
				sourceNode = _(languageLinks.nodes).findWhere(login: comment.user.login)

				if sourceNode?
					sourceIndex = _(languageLinks.nodes).indexOf(sourceNode)

					targetLanguage = _(languageLinks.nodes).findWhere(language: comment.language)
					unless targetLanguage?
						targetLanguage =
							language: comment.language
							group: 2
						languageLinks.nodes.push targetLanguage

					targetIndex = _(languageLinks.nodes).indexOf(targetLanguage)

					linkIdentifier = source: sourceIndex, target: targetIndex

					existingLink = _(languageLinks.links).findWhere(linkIdentifier)

					if existingLink?
						existingLink.value++
					else
						newLink = _({}).extend(linkIdentifier, value: 1)
						languageLinks.links.push newLink

		fs.writeFile './output/data/language-links.json', JSON.stringify(languageLinks, null, '\t'), (error)->
			if error? then console.log(error)
			console.log '   saved language-links!'
			resolve(data)

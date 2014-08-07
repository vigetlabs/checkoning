fs	 = require('fs')
RSVP = require('rsvp')
_	   = require('underscore')

module.exports = (data)->
	new RSVP.Promise (resolve)->
		console.log('...visualizing comment links')

		nodes = data.processed.team.map (user)->
			login:	      user.login
			name:         user.name
			icon:	        user.icon
			commentCount: 0


		commentLinks =
			nodes: nodes
			links: []

		for comment in data.processed.comments
			sourceNode = _(commentLinks.nodes).findWhere(login: comment.user.login)

			if sourceNode?
				sourceIndex = _(commentLinks.nodes).indexOf(sourceNode)

				targetPr = _(data.raw.prs).findWhere(url: comment.pull_request_url)

				if targetPr?
					targetNode = _(commentLinks.nodes).findWhere(login: targetPr.user.login)
					targetIndex = _(commentLinks.nodes).indexOf(targetNode)

					if sourceIndex != targetIndex && targetIndex != -1
						targetNode.commentCount++
						linkIdentifier = source: sourceIndex, target: targetIndex

						existingLink = _(commentLinks.links).findWhere(linkIdentifier)

						if existingLink?
							existingLink.value++
						else
							newLink = _({}).extend(linkIdentifier, value: 1)
							commentLinks.links.push newLink

		fs.writeFile './output/data/comment-links.json', JSON.stringify(commentLinks, null, '\t'), (error)->
			if error? then console.log(error)
			console.log '   saved comment-links!'
			resolve(data)

fs	 = require('fs')
RSVP = require('rsvp')
_		 = require('underscore')

module.exports = (data)->
	new RSVP.Promise (resolve)->
		console.log('...visualizing office links')

		officeLinks =
			nodes: []
			links: []

		for user in data.processed.team
			nodeExists = _(officeLinks.nodes).findWhere(name: user.office)
			officeLinks.nodes.push(
				name: user.office
				commentCount: 0
			) unless nodeExists

		for comment in data.processed.comments
			user = _(data.processed.team).findWhere(login: comment.user.login)
			sourceNode = _(officeLinks.nodes).findWhere(name: user.office)
			sourceIndex = _(officeLinks.nodes).indexOf(sourceNode)

			targetPr = _(data.raw.prs).findWhere(url: comment.pull_request_url)
			targetUser = _(data.processed.team).findWhere(login: targetPr.user.login)

			if targetUser?
        targetNode = _(officeLinks.nodes).findWhere(name: targetUser.office)
        targetIndex = _(officeLinks.nodes).indexOf(targetNode)

        if sourceIndex != targetIndex && targetIndex != -1
          targetNode.commentCount++
          linkIdentifier = source: sourceIndex, target: targetIndex
          existingLink = _(officeLinks.links).findWhere(linkIdentifier)

          if existingLink?
            existingLink.value++
          else
            newLink = _({}).extend(linkIdentifier, value: 1)
            officeLinks.links.push newLink

		fs.writeFile './output/data/office-links.json', JSON.stringify(officeLinks, null, '\t'), (error)->
			if error? then console.log(error)
			console.log '   saved office-links!'
			resolve(data)

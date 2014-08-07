RSVP	= require('rsvp')
_	 = require('underscore')

iconMap =
	averyvery     : 'davery'
	cwmanning     : 'cmanning'
	davist11      : 'tdavis'
	greypants     : 'dtello'
	jeremyfrank   : 'jfrank'
	jgarber623    : 'jgarber'
	mzlock        : 'mzlock'
	nhunzaker     : 'nhunzaker'
	ten1seven     : 'jfields'
	tommymarshall : 'tmarshall'
	solomonhawk   : 'shawk'
	reagent       : 'preagan'
	brianjlandau  : 'blandau'
	dce           : 'deisinger'
	yaychris      : 'cjones'
	zporter       : 'zporter'
	mackermedia   : 'mackerman'
	fosome        : 'rfoster'
	ltk           : 'lkurtz'
	efatsi        : 'efatsi'
	h0tl33t       : 'rstenberg'

officeMap =
	averyvery     : 'boulder'
	cwmanning     : 'durham'
	davist11      : 'charleston'
	greypants     : 'hq'
	jeremyfrank   : 'durham'
	jgarber623    : 'hq'
	mzlock        : 'hq'
	nhunzaker     : 'durham'
	ten1seven     : 'boulder'
	tommymarshall : 'hq'
	solomonhawk   : 'durham'
	reagent       : 'boulder'
	brianjlandau  : 'boulder'
	dce           : 'durham'
	yaychris      : 'durham'
	zporter       : 'durham'
	mackermedia   : 'boulder'
	fosome        : 'boulder'
	ltk           : 'boulder'
	efatsi        : 'boulder'
	h0tl33t       : 'hq'

getIcon = (user) ->
	if iconMap[user.login]?
		"http://viget.com/uploads/image/profile/person/#{iconMap[user.login]}.jpg"
	else
		user.avatar_url

getOffice = (user) ->
	if officeMap[user.login]?
		officeMap[user.login]
	else
		'undefined'

module.exports = (data)->
	new RSVP.Promise (resolve)->
		console.log('...building team')

		i = 0

		data.processed.team = _(data.raw.team).map (user)->
			name:		user.name
			icon:		getIcon(user)
			login:	user.login
			index:	i++
			office:	getOffice(user)

		resolve(data)

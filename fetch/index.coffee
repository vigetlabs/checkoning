require('./config')
	.then(require('./client'))
	.then(require('./org'))
	.then(require('./team'))
	.then(require('./repos'))
	.then(require('./prs'))
	.then(require('./comments'))
	.then(require('./save'))
	.catch (error)-> console.log error.stack

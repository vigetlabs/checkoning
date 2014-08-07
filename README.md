# Installation

Install coffeescript globally, then install all dependencies:

```
npm install coffee-script -g
npm install
```

<hr>

# Fetch the data

```
coffee fetch/index.coffee
```

This will trigger a very _large_ set of requests, so if you just want to build a little sample data, run:

```
coffee fetch/index.coffee --sample
```
<hr>

# Process the data

```
coffee process/index.coffee
```

<hr>

# View the data

```
coffee view.coffee
```

<hr>

# Caveats

* This project was designed as an experiment, not a product or polished tool, so gets pretty gross in some places. Hold your nose and keep going.
* The GitHub API request limit is 5000, and Checkoning doesn't do anything special to get around this limit. If you hit 5000 requests while running the `fetch` script, it just won't work. If you find this happening, you may want to adjust the fetch scripts to remove pagination, or trim the number of repos/PRs you examine.
* By default, checkoning only looks at private repos.
* Checkoning was written and tuned for Viget's FED and dev teams, meaning that it might not look great with smaller or larger teams. Tweak the values in output/js/visualizations manually to get better results.

<hr>

# Configuration

When you run the fetch command, you'll be prompted to enter your GitHub username, your password, your organization name, and your team ID (an integer).

If you get tired of doing this repeatedly, you can make a `.config.json` file in the following format:

```
{
	"username": "my_username",
	"password": "password123",
	"organization": "companyname",
	"team": 12345
}
```

Then, run the script with the `--config` flag.

```
coffee fetch/index.coffee --config
```

One way to find your team ID is visit your team's GitHub page in the browser and enter `$('.js-team-id').data('id')` in the console.

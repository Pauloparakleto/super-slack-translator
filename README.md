# Slacktranslator

A sinatra based application.

Translate to English sending message and translate to Portuguese incoming messages.

## Installation

After download this code, cd into it.

`bundle install`

`cp .env.sample .env`

Add your own slack api and openai keys.

You must chat in the "#social" slack channel. Your bot must be a "#social" member.

Add your ngrok url to the slack hook. Also make sure to add this same url to the ngrok url in the .env file.

> [!IMPORTANT]
> This was designed initially to run in development mode.

`bin/console`

`App::Slacktranslator.run!`

## Usage

Open your browser in `localhos:4567` the sinatra default.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

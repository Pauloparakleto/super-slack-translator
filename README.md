# Slacktranslator

A sinatra based application.

Translate to English sending message and translate to Portuguese incoming messages.

## Installation

After download this code, cd into it.

`bundle install`

`cp .env.sample .env`

add your own slack api and openai keys

`bin/console`

`App::Slacktranslator.run!`

## Usage

Open your browser in `localhos:4567` the sinatra default.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

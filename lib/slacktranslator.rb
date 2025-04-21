# frozen_string_literal: true
require 'dotenv'
Dotenv.load
require 'slack-ruby-client'
require_relative "slacktranslator/version"
require "byebug"
require 'sinatra/base'

module App
  # Instruction at https://api.slack.com/apps/A08P08P9J5Q/event-subscriptions?
  class ExampleApp < Sinatra::Base
    set :host_authorization, { permitted_hosts: [] }

    before do
      puts request.env.fetch("HTTP_HOST")
    end

    get("/") do
      erb :index
    end

    post("/channel/message") do
      content_type :json
      client = Slack::Translator.new
      message = request.body.read
      response = client.send_channel_message(message, '#social', :to_english)
      response.message.blocks.last.elements.last.elements.first.text.to_json
    end

    post('/') do
      data = JSON.parse request.body.read
      puts data
      data['challenge']
    end
  end
end

module Slack
  class Translator
    private attr_reader :client

    def initialize
      Slack.configure do |config|
        config.token = ENV['SLACK_API_TOKEN']
      end

      @client = Slack::Web::Client.new
    end

    def auth_test
      client.auth_test
    end

    def send_channel_message(text, channel, symbol = :to_english)
      client.chat_postMessage(channel:, text:, as_user: true )
    end
  end

  class Error < StandardError; end
  # Your code goes here...
end

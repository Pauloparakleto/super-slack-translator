# frozen_string_literal: true
require 'dotenv'
Dotenv.load
require 'slack-ruby-client'
require_relative "slacktranslator/version"
require "byebug"
require 'sinatra/base'
require "faraday"
require "json"

module App
  # Instruction at https://api.slack.com/apps/A08P08P9J5Q/event-subscriptions?
  class SlackTranslator < Sinatra::Base
    LAST_RESPONSE = { changed: false }
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
      response = client.send_channel_message(message, '#social', 'en')
      response.message.blocks.last.elements.last.elements.first.text.to_json
    end

    get '/latest_response' do
      content_type :json
      changed = LAST_RESPONSE[:changed]
      data = LAST_RESPONSE[:data]
      LAST_RESPONSE[:changed] = false if LAST_RESPONSE[:changed].eql?(true)
      {data: data, changed: changed}.to_json
    end

    post('/') do
      content_type :json
      client = Slack::Translator.new
      puts "event sent"
      data = JSON.parse request.body.read
      puts data
      return if data.fetch('event').fetch('bot_id', false)
      text = data.fetch('event').fetch('text')
      message = client.translate_message(text)
      puts message
      LAST_RESPONSE[:data] = message.to_json
      LAST_RESPONSE[:changed] = true
      puts "from post slack bot last response: #{LAST_RESPONSE}"
      status 200
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

    def send_channel_message(text, channel, language = 'en')
      translated_text = translate_message(text, language)

      client.chat_postMessage(channel:, text: translated_text, as_user: true )
    end

    def translate_message(text, translation_option = 'pt')
      translator_parser = { pt: 'Portuguese', en: 'English' }
      language = translator_parser["#{translation_option}".to_sym]
      begin
        conn = Faraday.new(
          url: 'https://api.openai.com/v1/chat/completions',
          headers: {
            'Content-Type' => 'application/json',
            'Authorization' => "Bearer #{ENV['OPENAI_API_KEY']}"
          }
        )

        response = conn.post do |request|
          request.body = {
            model: "gpt-4o-mini",
            store: true,
            messages: [
              { role: "user", content: "Translate the following to #{language}: #{text}. Only include in the message response the translated text." }
            ]
          }.to_json
        end

        JSON.parse(response.body).fetch('choices').first.fetch('message').fetch('content')
      rescue StandardError => exception
        puts "exception on translating message"
        puts exception
        text
      end
    end
  end

  class Error < StandardError; end
  # Your code goes here...
end

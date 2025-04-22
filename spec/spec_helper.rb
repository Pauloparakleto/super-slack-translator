# frozen_string_literal: true

require "slacktranslator"
require "byebug"
VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :faraday
  config.debug_logger = File.open('development.log', 'w')
  config.before_record do |interaction|
   interaction.response.body.gsub!(/"user_id\":["^\"][A-Z | 0-9]+/, "\"user_id\":\"SECRET")
   interaction.response.body.gsub!(/"user\":["^\"][A-Z | 0-9]+/, "\"user\":\"SECRET")
   interaction.response.body.gsub!(/"team_id\":["^\"][A-Z | 0-9]+/, "\"team_id\":\"SECRET")
   interaction.response.body.gsub!(/"bot_id\":["^\"][A-Z | 0-9]+/, "\"bot_id\":\"SECRET")
   interaction.response.body.gsub!(/"channel\":["^\"][A-Z | 0-9]+/, "\"channel\":\"SECRET")
   interaction.response.body.gsub!(/"app_id\":["^\"][A-Z | 0-9]+/, "\"app_id\":\"SECRET")
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

# frozen_string_literal: true

require 'simplecov'

SimpleCov.start do
  add_filter %r{^/spec/}
end

require 'bundler/setup'
require 'youlend'
require 'vcr'
require 'dotenv'
require 'pry-byebug'

Dotenv.load

Youlend.configure do |config|
  config.client_id = ENV['YOULEND_CLIENT_ID']
  config.client_secret = ENV['YOULEND_CLIENT_SECRET']
end

VCR.configure do |config|
  config.cassette_library_dir = 'vcr_cassettes'
  config.hook_into :webmock
  config.filter_sensitive_data('<CLIENT_ID>') do
    ENV['YOULEND_CLIENT_ID']
  end

  config.filter_sensitive_data('<CLIENT_SECRET>') do
    ENV['YOULEND_CLIENT_SECRET']
  end

  config.filter_sensitive_data('<Bearer>') do |interaction|
    interaction.request.headers['Authorization']&.first
  end

  config.filter_sensitive_data('<TOKEN>') do |interaction|
    if interaction.response.body.match?(/access_token/)
      JSON.parse(interaction.response.body)['access_token']
    end
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

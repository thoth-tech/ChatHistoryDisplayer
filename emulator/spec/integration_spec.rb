# frozen_string_literal: true

require 'capybara/rspec'
require './main'

Capybara.configure do |config|
  config.app_host = 'http://localhost:3000'
  config.app = Sinatra::Base
  config.default_driver = :selenium_chrome_headless
  config.server_port = 4567
end

# frozen_string_literal: true

require 'capybara/rspec'
require './main'

# configuring capybara to not start the server (as `docker compose up` should be ran at root),
# set the app_host to the react web app, default driver to headless chrome, and the server port
Capybara.configure do |config|
  config.run_server = false
  config.app_host = 'http://localhost:3000'
  config.app = Sinatra::Base
  config.default_driver = :selenium_chrome_headless
  config.server_port = 4567
end

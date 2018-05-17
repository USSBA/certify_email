require "bundler/setup"
require "certify_email"
require "byebug"
require "faker"
require 'excon'

Dir['./spec/support/**/*.rb'].each { |f| require f }

# configure the CertifyEmail module for testing

CertifyEmail.configure do |config|
  # config.api_url = "http://foo.bar/"
  # config.excon_timeout = 6
  config.log_level = "unknown"
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

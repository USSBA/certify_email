require "byebug"
require "certify_email/configuration"
require "certify_email/error"
require "certify_email/resource"
require "certify_email/version"
require "certify_email/resources/default_logger"
require "certify_email/resources/email"

# the base CertifyEmail module that wraps all api calls
module CertifyEmail
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end

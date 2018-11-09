module CertifyEmail
  # configuration module
  class Configuration
    # TODO: add API specific attrs
    attr_accessor :excon_timeout, :api_key, :api_url, :api_version, :path_prefix, :logger, :log_level, :send_email_path

    # main api endpoint
    def initialize
      @excon_timeout = 20
      @api_key = "fake_api_key" #TODO: set to nil once we start using API Gateways
      @api_url = "http://localhost:3008"
      @api_version = 1
      @path_prefix = "email_api"
      @logger = nil
      @log_level = "debug"
      @send_email_path = "send_email"
    end
  end
end

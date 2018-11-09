require 'json'
require 'excon'

module CertifyEmail
  # Controls the API connection
  class ApiConnection
    attr_accessor :conn
    def initialize(url, timeout, api_key = nil)
      params = {
        connect_timeout: timeout,
        read_timeout: timeout,
        write_timeout: timeout
      }
      params[:headers] = { 'x-api-key' => api_key } unless api_key.nil?
      @conn = Excon.new(url, params)
    end

    def request(options)
      add_version_to_header options
      @conn.request(options)
    end

    def add_version_to_header(options)
      version = CertifyEmail.configuration.api_version
      # TODO: Modify the header to match the api you are connecting to
      if options[:headers]
        options[:headers].merge!('Accept' => "application/sba.email-api.v#{version}")
      else
        options.merge!(headers: { 'Accept' => "application/sba.email-api.v#{version}" })
      end
    end
  end

  # base resource class
  # rubocop:disable Style/ClassVars
  class Resource
    @@connection = nil

    # excon connection
    def self.connection
      @@connection ||= ApiConnection.new api_url, excon_timeout, api_key
    end

    def self.clear_connection
      @@connection = nil
    end

    def self.excon_timeout
      CertifyEmail.configuration.excon_timeout
    end

    def self.api_key
      CertifyEmail.configuration.api_key
    end

    def self.api_url
      CertifyEmail.configuration.api_url
    end

    def self.path_prefix
      CertifyEmail.configuration.path_prefix
    end

    def self.logger
      CertifyEmail.configuration.logger ||= (DefaultLogger.new log_level).logger
    end

    def self.log_level
      CertifyEmail.configuration.log_level
    end

    def self.send_email_path
      CertifyEmail.configuration.send_email_path
    end

    def self.handle_excon_error(error)
      logger.error [error.message, error.backtrace.join("\n")].join("\n")
      CertifyEmail.service_unavailable error.message
    end

    #TODO: add methods to get API specific paths, e.g,:
    #
    # def self.activities_path
    #   CertifyEmail.configuration.activities_path
    # end

    # json parse helper
    def self.json(response)
      JSON.parse(response)
    end

    # empty params
    def self.empty_params(params)
      params.nil? || params.empty?
    end

    def self.return_response(body, status)
      { body: body, status: status }
    end

    def self.symbolize_params(params)
      # rebuild params as symbols, dropping ones as strings
      symbolized_params = {}
      params.each do |key, value|
        if key.is_a? String
          symbolized_params[key.to_sym] = value
        else
          symbolized_params[key] = value
        end
      end
      symbolized_params
    end
  end
  # rubocop:enable Style/ClassVars
end

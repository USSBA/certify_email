module CertifyEmail
  # Email class that handles getting and creating new Email objects
  class Email < Resource

    # get list of Emails given the parameters to search for
    # rubocop:disable Metrics/AbcSize
    def self.where(params = nil)
      return CertifyEmail.bad_request if empty_params(params)
      safe_params = email_safe_params params
      return CertifyEmail.unprocessable if safe_params.empty?
      response = connection.request(method: :get,
                                    path: build_where_Emails_path(safe_params))
      return_response(json(response.data[:body]), response.data[:status])
    rescue Excon::Error => error
      handle_excon_error(error)
    end
    singleton_class.send(:alias_method, :find, :where)
    # rubocop:enable Metrics/AbcSize

    def self.create(params = nil)
      # create_soft(params)
      return CertifyEmail.bad_request if empty_params(params)
      safe_params = email_safe_params(params)
      return CertifyEmail.unprocessable if safe_params.empty?
      response = connection.request(method: :post,
                                    path: build_create_Emails_path,
                                    body: safe_params.to_json,
                                    headers:  { "Content-Type" => "application/json" })
      return_response(parse_body(response.data[:body]), response.data[:status])
    rescue Excon::Error => error
      handle_excon_error(error)
    end

    # gem method for accessing the API export method and returning a csv of the data
    def self.export(params = nil)
      return CertifyEmail.bad_request if empty_params(params) || params[:application_id].nil?
      response = connection.request(method: :get,
                                    path: build_export_Emails_path(params))
      return_response(response.data[:body], response.data[:status])
    rescue Excon::Error => error
      handle_excon_error(error)
    end

    private_class_method

    # returns the body as a parsed JSON hash, or as a simple hash if nil
    def self.parse_body(body)
      body.empty? ? { message: 'No Content' } : json(body)
    end

    # helper for white listing parameters
    def self.email_safe_params(params)
      permitted_keys = %w[id recipient_id application_id event_type subtype options body page per_page]
      symbolize_params(params.select { |key, _| permitted_keys.include? key.to_s })
    end

    def self.build_where_Emails_path(params)
      "#{path_prefix}/#{Emails_path}?#{URI.encode_www_form(params)}"
    end

    def self.build_create_Emails_path
      "#{path_prefix}/#{Emails_path}"
    end

    def self.build_export_Emails_path(params)
      "#{path_prefix}/#{Emails_export_path}?column_separator=#{column_separator}&#{URI.encode_www_form(params)}"
    end
  end
end

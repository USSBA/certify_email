module CertifyEmail
  # Email class that handles getting and creating new Email objects
  class Email < Resource
    # rubocop:disable Metrics/AbcSize
    def self.send(params = nil)
      return CertifyEmail.bad_request if empty_params(params)
      safe_params = email_safe_params(params)
      return CertifyEmail.unprocessable if safe_params.empty?
      response = connection.request(method: :post,
                                    path: build_create_emails_path,
                                    body: safe_params.to_json,
                                    headers:  { "Content-Type" => "application/json" })
      return_response(parse_body(response.data[:body]), response.data[:status])
    rescue Excon::Error => error
      handle_excon_error(error)
    end
    # rubocop:enable Metrics/AbcSize

    private_class_method

    # returns the body as a parsed JSON hash, or as a simple hash if nil
    def self.parse_body(body)
      body.empty? ? { message: 'No Content' } : json(body)
    end

    # helper for white listing parameters
    def self.email_safe_params(params)
      permitted_keys = %w[id template recipient message]
      symbolize_params(params.select { |key, _| permitted_keys.include? key.to_s })
    end

    def self.build_create_emails_path
      "#{path_prefix}/#{send_email_path}"
    end
  end
end

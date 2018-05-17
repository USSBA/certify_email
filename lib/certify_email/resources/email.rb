module CertifyEmail
  # Email class that handles getting and creating new Email objects
  class Email < Resource
    def self.send_email(params = nil)
      return CertifyEmail.bad_request if empty_params(params)
      response = connection.request(method: :post,
                                    path: build_create_emails_path,
                                    body: params.to_json,
                                    headers:  { "Content-Type" => "application/json" })
      return_response(parse_body(response.data[:body]), response.data[:status])
    rescue Excon::Error => error
      handle_excon_error(error)
    end

    private_class_method

    # returns the body as a parsed JSON hash, or as a simple hash if nil
    def self.parse_body(body)
      body.empty? ? { message: 'No Content' } : json(body)
    end

    def self.build_create_emails_path
      "#{path_prefix}/#{send_email_path}"
    end
  end
end

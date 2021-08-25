require 'net/http'

module FastBound
  module API

    ROOT_URL          = 'https://cloud.fastbound.com'.freeze
    USER_AGENT        = "FastBoundRubyGem/#{FastBound::VERSION}".freeze
    FILE_UPLOAD_ATTRS = {
      permitted: %i( file_name file_type file_contents ).freeze,
      reqired:   %i( file_type file_contents ).freeze,
    }

    def get_request(client, endpoint)
      request = Net::HTTP::Get.new(request_url(client, endpoint))

      submit_request(client, request)
    end

    def post_request(client, endpoint, data = {})
      request = Net::HTTP::Post.new(request_url(client, endpoint))

      submit_request(client, request, data)
    end

    def post_file_request(client, endpoint, file_data)
      request = Net::HTTP::Post.new(request_url(client, endpoint))

      submit_file_request(client, request, file_data)
    end

    private

    def submit_request(client, request, data = {})
      set_request_headers(client, request)

      request.body = data.is_a?(Hash) ? data.to_json : data

      process_request(request)
    end

    def submit_file_request(client, request, file_data)
      boundary = ::SecureRandom.hex(15)

      headers.merge!(content_type_header("multipart/form-data; boundary=#{boundary}"))

      build_multipart_request_body(request, file_data, boundary)
      set_request_headers(client, request)
      process_request(request)
    end

    def process_request(request)
      uri = URI(request.path)

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request(request)
      end

      FastBound::Response.new(response)
    end

    def build_multipart_request_body(request, file_data, boundary)
      file_type     = file_data[:file_type]
      file_contents = file_data[:file_contents]
      file_name     = file_data[:file_name] || "ffl-document.#{file_type}"
      content_type  = "application/#{file_data[:file_type]}"

      body = []
      body << "--#{boundary}\r\n"
      body << "Content-Disposition: form-data; name=\"file\"; filename=\"#{file_name}\"\r\n"
      body << "Content-Type: #{content_type}\r\n"
      body << "\r\n"
      body << "#{file_contents}\r\n"
      body << "--#{boundary}--\r\n"

      request.body = body.join
    end

    def set_request_headers(client, request)
      request['User-Agent'] = USER_AGENT
      request['Authorization'] = ['Basic', Base64.strict_encode64(client.api_key + ':')].join(' ')
    end

    def request_url(client, endpoint)
      [ROOT_URL, client.account_number, 'api', endpoint].join('/')
    end

    def standardize_body_data(submitted_data, permitted_data_attrs)
      _submitted_data = submitted_data.deep_transform_keys(&:to_sym)
      permitted_data = (_submitted_data.select! { |k, v| permitted_data_attrs.include?(k) } || _submitted_data)

      permitted_data.deep_transform_keys { |k| k.to_s.camelize(:lower) }
    end

  end
end

module FastBound
  class Response

    attr_accessor :success

    def initialize(response)
      @response = response

      case @response
      when Net::HTTPUnauthorized
        raise FastBound::Error::NotAuthorized.new(@response.body)
      when Net::HTTPNotFound
        raise FastBound::Error::NotFound.new(@response.body)
      when Net::HTTPNoContent
        raise FastBound::Error::NoContent.new(@response.body)
      when Net::HTTPOK, Net::HTTPSuccess
        self.success = true
        _data = (JSON.parse(@response.body) if @response.body.present?)

        @data = case
        when _data.is_a?(Hash)
          _data.deep_symbolize_keys
        when _data.is_a?(Array)
          _data.map(&:deep_symbolize_keys)
        end
      else
        if FastBound.config.full_debug?
          puts "-- DEBUG: #{self}: RequestError: #{@response.inspect}"
        end

        raise FastBound::Error::RequestError.new([@response.body, @response.message].reject(&:blank?).join(" | "))
      end
    end

    def [](key)
      @data[key]
    end

    def body
      @data
    end

    def fetch(key)
      @data.fetch(key)
    end

    def success?
      !!success
    end

  end
end

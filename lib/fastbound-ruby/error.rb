module FastBound
  class Error < StandardError

    class NoContent < FastBound::Error; end
    class NotAuthorized < FastBound::Error; end
    class NotFound < FastBound::Error; end
    class RequestError < FastBound::Error; end
    class TimeoutError < FastBound::Error; end

  end
end

# Bad Request Error.
class BadRequestError < BaseError
  # Fetch status code.
  def status_code
    400
  end

  class << self
    # Resource not found.
    def resource_not_found(field = nil)
      self.new(code: :resource_not_found, field: field)
    end
  end
end

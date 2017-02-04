# Bad Request Error.
class BadRequestError < BaseError

  def initialize(opts = {})
    super(opts)
    fail ArgumentError if @code.nil? || @field.nil?
  end

  # Fetch status code.
  def status_code
    400
  end

  # Generate error hash of views format.
  def format_views_error
    code = @code.is_a?(Array) ? @code : [@code]
    { @field => code }
  end

  # Generate error hash of api format.
  def format_api_error
    { @field => @code  }
  end

  class << self
    # Resource not found.
    def resource_not_found(field = nil)
      self.new(code: :resource_not_found, field: field)
    end
  end
end

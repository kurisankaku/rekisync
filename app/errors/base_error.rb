# Error base class.
class BaseError < StandardError
  attr_accessor :code
  attr_accessor :field

  def initialize(opts = {})
    @code = opts[:code]
    @field = opts[:field]
  end

  # Fetch status code.(ex. 400)
  def status_code
    raise "Override #status_code"
  end
end

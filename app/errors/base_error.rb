# Error base class.
class BaseError < StandardError
  attr_accessor :code
  attr_accessor :field
  attr_accessor :resource

  def initialize(opts = {})
    @code = opts[:code] || nil
    @field = opts[:field] || nil
    @resource = opts[:resource] || nil
  end

  # Fetch status code.(ex. 400)
  def status_code
    fail "Override #status_code"
  end
end

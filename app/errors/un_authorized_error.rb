# UnAuthorized Error.
class UnAuthorizedError < BaseError
  # Fetch status code.
  def status_code
    401
  end
end

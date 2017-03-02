class NotFoundPageError < BaseError
  # Fetch status code.
  def status_code
    404
  end
end

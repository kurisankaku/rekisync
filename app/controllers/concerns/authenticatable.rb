# Authenticate module.
module Authenticatable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
  end

  # Authenticate user.
  def authenticate_user!
    @current_user = User.find_by_id(session[:id]) || (fail UnAuthorizedError.new)
    fail BadRequest.new(:unconfirmed, :email), "Unconfirmed account email." unless @current_user.confirmed?
  end

  # Fetch current user.
  def current_user
    @current_user
  end
end

# Authenticate module.
module Authenticatable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
  end

  # Authenticate user.
  def authenticate_user!
    self.current_user = User.find_by_id(session[:user_id]) || (fail UnAuthorizedError.new)
    fail BadRequest.new(:unconfirmed, :email), "Unconfirmed account email." unless current_user.confirmed?
  end

  # Set current_user.
  def current_user=(user)
    session[:user_id] = user.id if user.present?
    @current_user_no_direct_call = user
  end

  # Fetch current user.
  def current_user
    @current_user_no_direct_call
  end
end

# Authenticate module.
module Authenticatable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
  end

  # Authenticate user.
  def authenticate_user!
    user = User.find_by_id(session[:user_id])
    if user.nil? || !user.confirmed?
      fail UnAuthorizedError.new
    else
      self.current_user = user
    end
  end

  # Set current_user.
  def current_user=(user)
    session[:user_id] = user.id if user.present?
    @current_user_no_direct_call = user
  end

  # Fetch current user.
  def current_user
    @current_user_no_direct_call || User.find_by_id(session[:user_id])
  end

  # Fetch current user id.
  def current_user_id
    session[:user_id]
  end
end

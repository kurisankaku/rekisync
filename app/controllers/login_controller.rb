# Login controller.
class LoginController < ApplicationController
  skip_before_action :authenticate_user!
  # Show login page.
  def index
  end

  # Login.
  def create
  end
end

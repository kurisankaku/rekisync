# Login controller.
class LoginController < ApplicationController
  skip_before_action :authenticate_user!
  # Show login page.
  def index
  end

  # Login.
  def create
    @error = execute_action do
      self.current_user = AccountService.new.authenticate(params)
    end
    if @error.present?
      @params = params.slice(:account_name)
      render :index, status: 400
    else
      redirect_to root_path
    end
  end

  # Logout.
  def destroy
    self.current_user = nil
    reset_session

    redirect_to login_index_path
  end
end

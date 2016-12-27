# Sign up controller.
class SignUpController < ApplicationController
  skip_before_action :authenticate_user!
  # Index.
  def index
  end

  # Create new account.
  def create
    @error = execute_action do
      account_service.create(params)
    end
    if @error.present?
      @params = params
      render :index, status: 400
    end
  end

  # Confirm email.
  def confirm_email
    self.current_user = account_service.confirm_email(params[:token])
    redirect_to root_path
  end

  private

  # Fetch account service.
  def account_service
    @account_service ||= AccountService.new
  end
end

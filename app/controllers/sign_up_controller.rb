# Sign up controller.
class SignUpController < ApplicationController
  skip_before_action :authenticate_user!
  # Index.
  def index
  end

  # Create new account.
  def create
    @error = execute_action do
      self.current_user = account_service.create(params)
    end
    if @error.present?
      @params = params.except(:password, :password_confirmation)
      render :index, status: 400
    end
  end

  private

  # Fetch account service.
  def account_service
    @account_service ||= AccountService.new
  end
end

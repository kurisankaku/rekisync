# Sign up controller.
class SignUpController < ApplicationController
  skip_before_action :authenticate_user!
  # Index.
  def index
  end

  # Create new account.
  def create
    begin
      AccountService.create(params)
      render "create"
    rescue ActiveRecord::RecordInvalid => e
      @params = params
      @errors = e.record.errors.details
      render "index"
    end
  end

  # Confirm email.
  def confirm_email
    AccountService.confirm_email(params[:token])
    redirect_to root_url
  end
end

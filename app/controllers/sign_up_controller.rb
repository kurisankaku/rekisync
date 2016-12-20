# Sign up controller.
class SignUpController < ApplicationController

  # Index.
  def index
  end

  # Create new account.
  #
  # @param [ActionController::Parameters] params
  def create
    begin
      @user = AccountService.create(params)
    rescue ActiveRecord::RecordInvalid => e
      @params = params
      @errors = e.record.errors.details
    end
    render "index"
  end
end

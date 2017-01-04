# Confirm email controller.
class ConfirmEmailController < ApplicationController
  skip_before_action :authenticate_user!

  # Index.
  def index
    user = User.find_by_id(self.current_user_id)
    fail UnAuthorizedError.new if user.nil?
  end

  def show
    self.current_user = account_service.confirm_email(params[:id])
    redirect_to root_path
  end

  # Resend confirm email.
  def resend
    @error = execute_action do
      account_service.resend_confirmation_notification(self.current_user_id)
    end

    if @error.present?
      render :index, status: 400
    end
  end

  # update email.
  def update_email
    @error = execute_action do
      account_service.update_email(params.merge(id: self.current_user_id))
    end

    if @error.present?
      @params = params
      render :index, status: 400
    end
  end

  private

  # Fetch account service.
  def account_service
    @account_service ||= AccountService.new
  end
end

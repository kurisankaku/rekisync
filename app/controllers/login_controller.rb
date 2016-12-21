# Login controller.
class LoginController < ApplicationController
  skip_before_action :authenticate_user!
  # Show login page.
  def index
  end

  # Login.
  def create
    @errors = { record: {}, bad: {} }
    begin
      self.current_user = AccountService.authenticate(params)
      redirect_to root_path
    rescue ActiveRecord::RecordInvalid => e
      @params = params
      @errors[:record] = e.record.errors.details

      render :index
    rescue BadRequestError => e
      @params = params
      @errors[:bad] = e

      render :index
    end
  end
end

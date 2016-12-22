module Settings
  # Account controller.
  class AccountsController < ApplicationController
    # Index page.
    def show
    end

    # Update account password.
    def update
      params[:id] = self.current_user.id
      begin
        AccountService.update_password(params)
        redirect_to settings_account_path
      rescue ActiveRecord::RecordInvalid => e
        @errors = { record: e.record.errors.details, bad: {} }
        render :show
      rescue BadRequestError => e
        @errors = { record: {}, bad: e }
        render :show
      end
    end

    # Delete account.
    def destroy
      params[:id] = self.current_user.id
      begin
        AccountService.delete(params)
        redirect_to login_index_path
      rescue ActiveRecord::RecordInvalid => e
        @errors = { record: e.record.errors.details }
        render :show
      end
    end
  end
end

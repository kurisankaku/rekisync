module Settings
  # Account controller.
  class AccountsController < ApplicationController
    # Index page.
    def show
    end

    # Update account password.
    def update
      @error = execute_action do
        AccountService.update_password(params.merge(id: self.current_user.id))
      end
      if @error.present?
        render :show
      else
        redirect_to settings_account_path
      end
    end

    # Delete account.
    def destroy
      @error = execute_action do
        AccountService.delete(params.merge(id: self.current_user.id))
      end
      if @error.present?
        render :show
      else
        redirect_to login_index_path
      end
    end
  end
end

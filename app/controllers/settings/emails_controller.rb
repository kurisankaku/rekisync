module Settings
  # Email controller.
  class EmailsController < ApplicationController
    # Show update email page.
    def show
    end

    # Update Email.
    def update
      @error = execute_action do
        AccountService.update_email(params.merge(id: self.current_user.id))
      end

      if @error.present?
        render :show, status: 400
      end
    end
  end
end

module Settings
  # Email controller.
  class EmailsController < ApplicationController
    # Show update email page.
    def show
    end

    # Update Email.
    def update
      begin
        AccountService.update_email(params.merge(id: self.current_user.id))
      rescue ActiveRecord::RecordInvalid => e
        @params = params
        @errors[:record] = e.record.errors.details

        render :show
      rescue BadRequestError => e
        @params = params
        @errors[:bad] = e

        render :show
      end
    end
  end
end

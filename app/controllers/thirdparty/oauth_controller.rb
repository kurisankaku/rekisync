module Thirdparty
  # OAuth controller.
  class OauthController < ApplicationController
    # Callback from twitter.
    def callback_twitter
      #TODO Find user by auth_hash
      user = nil
      if user.present? && user.confirmed?
        self.current_user = user
        redirect_to root_path
      else
        @params = { email: "", name: "" }
        render :callback
      end
    end

    # Create account.
    def create
      @error = execute_action do
      end

      if @error.present?
        @params = params
        render :callback, status: 400
      else
        redirect_to root_path
      end
    end

    private

    # fetch omniauth info.
    def auth_hash
      request.env['omniauth.auth']
    end
  end
end

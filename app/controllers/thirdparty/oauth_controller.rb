module Thirdparty
  # OAuth controller.
  class OauthController < ApplicationController
    skip_before_action :authenticate_user!
    # Callback from oauth.
    def callback
      self.current_user = account_service.find(provider: auth_hash[:provider], uid: auth_hash[:uid])

      if self.current_user.nil?
        session[:auth_hash] = auth_hash
        @params = { email: "", name: auth_hash[:info][:nickname] }
        render :callback
      elsif self.current_user.confirmed?
        redirect_to root_path
      else
        redirect_to confirm_email_index_path
      end
    end

    # Create account.
    def create
      @error = execute_action do
        account_service.create(params, auth_hash: session[:auth_hash])
      end

      if @error.present?
        @params = params
        render :callback, status: 400
      else
        session[:auth_hash] = nil
      end
    end

    private

    # fetch omniauth info.
    def auth_hash
      request.env["omniauth.auth"]
    end

    # Fetch account service.
    def account_service
      @account_service ||= AccountService.new(strategy: ::AccountStrategies::ThirdParty.new)
    end
  end
end

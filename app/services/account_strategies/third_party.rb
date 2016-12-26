module AccountStrategies
  class ThirdParty
    # Create account.
    #
    # @param [ActionController::Parameters] params parameters.
    # @param [Hash] option
    # @return [User] created account.
    def create(params, option = {})
      user = User.where(email: params[:email], confirmed_at: nil).first
      if user.nil?
        user = User.new(sign_up_params(params))
      end

      user.skip_confirmation! if option[:skip_confirmation]
      user.tap(&:save!)
    end

    # Authenticate account.
    #
    # @param [ActionController::Parameters] params parameters.
    # @return [User] user.
    def authenticate(params)
    end

    # Find account by third party params.
    #
    # @param [ActionController::Parameters] params parameters.
    # @return [User] account.
    def find(params)
      token = ThirdPartyAccessToken.where(provider: params[:provider], uid: params[:uid]).first
      token.try(:user)
    end

    private

    # Build third party access token object by params.
    #
    # @param [Hash] params
    # @return [ThirdPartyAccessToken] object.
    def build_third_party_access_token(params)
      ThirdPartyAccessToken.new({
          uid: params[:uid],
          provider: params[:provider],
          token: params[:token],
          refresh_token: params[:refresh_token]
          expires_in: params[:expires_in]
        })
    end
  end
end

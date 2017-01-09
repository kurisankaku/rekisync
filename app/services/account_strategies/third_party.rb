module AccountStrategies
  class ThirdParty
    # Create account.
    #
    # @param [ActionController::Parameters] params parameters.
    # @param [Hash] option
    # @return [User] created account.
    def create(params, option = {})
      token = find_access_token(option[:auth_hash])
      if token.nil?
        user = User.new(sign_up_params(params))
        user.third_party_access_tokens << ThirdPartyAccessToken.new(third_party_access_token_params(option[:auth_hash]))

        user.skip_confirmation! if option[:skip_confirmation]
        user.tap(&:save!)
      else
        token.update!(third_party_access_token_params(option[:auth_hash]))
        token.user.update!(sign_up_params(params))
        token.user
      end
    end

    # Authenticate account.
    #
    # @param [ActionController::Parameters] params parameters.
    # @return [User] user.
    def authenticate(params)
      token = find_access_token(params[:auth_hash])
      return nil if token.nil?

      token.update!(third_party_access_token_params(params[:auth_hash]))
      user = token.user
      return nil if user.nil?

      user.last_sign_in_at = user.current_sign_in_at
      user.current_sign_in_at = Time.zone.now
      user.failed_attempts = 0
      user.locked_at = nil
      user.tap(&:save!)
    end

    private

    # Find access token by third party params.
    #
    # @param [Hash] params parameters.
    # @return [ThirdPartyAccessToken] access token.
    def find_access_token(params)
      ThirdPartyAccessToken.where(provider: params[:provider], uid: params[:uid]).first
    end

    # Return third party access token params.
    #
    # @param [Hash] params reqeust.env["omniauth.auth"] hash.
    # @return [Hash] ThirdPartyAccessToken model attributes.
    def third_party_access_token_params(params)
      case params[:provider]
      when "twitter"
        {
          uid: params[:uid],
          provider: params[:provider],
          token: params[:credentials].try(:[], :token)
        }
      when "google_oauth2"
        {
          uid: params[:uid],
          provider: params[:provider],
          token: params[:credentials].try(:[], :token),
          refresh_token: params[:credentials].try(:[], :refresh_token),
          expires_in: params[:credentials].try(:[], :expires_at)
        }
      when "facebook"
        {
          uid: params[:uid],
          provider: params[:provider],
          token: params[:credentials].try(:[], :token),
          expires_in: params[:credentials].try(:[], :expires_at)
        }
      end
    end

    # Sanitize params for sign_up action.
    #
    # @param [ActionController::Parameters] params parameters.
    # @return [ActionController::Parameters] params
    def sign_up_params(params)
      params.permit(:name, :email)
    end
  end
end

module AccountStrategies
  class Origin
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

    # Find account by params.
    #
    # @param [ActionController::Parameters] params parameters.
    # @return [User] account.
    def find(params)
      User.find_by_email(params[:email])
    end

    # Authenticate account.
    #
    # @param [ActionController::Parameters] params parameters.
    # @return [User] user.
    def authenticate(params)
      user = User.where(email: params[:account_name]).or(User.where(name: params[:account_name])).first

      if user.nil?
        fail BadRequestError.new(code: :invalid_account_name_or_password, field: :account_name), "Invalid account name or password."
      end

      if user.locked?
        fail BadRequestError.new(code: :account_locked, field: :account_name), "Account is locked."
      end

      if !user.authenticate(params[:password])
        user.increase_failed_attempts!
        fail BadRequestError.new(code: :invalid_account_name_or_password, field: :account_name), "Invalid account name or password."
      end

      user.last_sign_in_at = user.current_sign_in_at
      user.current_sign_in_at = Time.zone.now
      user.failed_attempts = 0
      user.locked_at = nil
      user.tap(&:save!)
    end

    private

    # Sanitize params for sign_up action.
    #
    # @param [ActionController::Parameters] params parameters.
    # @return [ActionController::Parameters] params
    def sign_up_params(params)
      params.permit(:password, :password_confirmation, :name, :email)
    end
  end
end

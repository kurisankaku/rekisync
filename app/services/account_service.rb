# Management account.
class AccountService
  def initialize(option = {})
    @strategy = option[:strategy] || ::AccountStrategies::Origin.new
  end

  # Create account.
  #
  # @param [ActionController::Parameters] params parameters.
  # @param [Hash] option
  # @return [User] created account.
  def create(params, option = {})
    @strategy.create(params, option)
  end

  # Authenticate account.
  #
  # @param [ActionController::Parameters] params parameters.
  # @return [User] user.
  def authenticate(params)
    @strategy.authenticate(params)
  end

  # Confirm email by token.
  #
  # @param [String] token token string.
  # @return [User] confirmed user.
  def confirm_email(token)
    user = User.find_by_confirmation_token(token)
    if user.nil?
      fail BadRequestError.user_not_found(:token), "User not found by token."
    end

    user.confirm!
  end

  # Update email.
  #
  # @param [ActionController::Parameters] params parameters.
  # @return [User] updated user.
  def update_email(params)
    user = User.find_by_id(params[:id])
    if user.nil?
      fail BadRequestError.user_not_found(:id), "User not found."
    end

    user.update!(email: params[:email])
    user
  end

  # Update name.
  #
  # @param [ActionController::Parameters] params parameters.
  # @return [User] updated user.
  def update_name(params)
    user = User.find_by_id(params[:id])
    if user.nil?
      fail BadRequestError.user_not_found(:id), "User not found."
    end

    correct_password?(user, params[:password], :password)
    user.update!(name: params[:name])
    user
  end

  # Update password.
  #
  # @param [ActionController::Parameters] params parameters.
  # @return [User] updated user.
  def update_password(params)
    user = User.find_by_id(params[:id])
    if user.nil?
      fail BadRequestError.user_not_found(:id), "User not found."
    end

    correct_password?(user, params[:old_password], :old_password)
    user.update!(update_password_params(params))
    user
  end

  # Reset password by token.
  #
  # @params [ActionController::Parameters] params parameters.
  # @return [User] updated user.
  def reset_password(params)
    user = User.find_by_reset_password_token(params[:token])
    if user.nil?
      fail BadRequestError.user_not_found(:token), "User not found by token."
    end

    user.reset_password!(params[:password], params[:password_confirmation])
    user
  end

  # Issue reset password token.
  #
  # @params [ActionController::Parameters] params
  # @return [User] updated user.
  def issue_reset_password_token(params)
    user = User.find_by_email(params[:email])
    if user.nil?
      fail BadRequestError.new(code: :not_exists, field: :email), "Not exists email."
    end

    user.tap(&:issue_reset_password_token!)
  end

  # Delete account
  #
  # @param [ActionController::Parameters] params
  # @return [User] delted user.
  def delete(params)
    user = User.find_by_id(params[:id])
    if user.nil?
      fail BadRequestError.user_not_found(:id), "User not found."
    end

    correct_password?(user, params[:password], :password)
    user.destroy
  end

  # Resend confirmation notification.
  #
  # @param [String] id user id.
  # @return [User] user.
  def resend_confirmation_notification(id)
    user = User.find_by_id(id)
    if user.nil?
      fail BadRequestError.user_not_found(:id), "User not found."
    end

    if user.confirmed?
      fail BadRequestError.new(code: :already_confirmed, field: :email), "User email already confirmed."
    end

    user.resend_confirmation_notification!
    user
  end

  private

  # Sanitize params for update_password action.
  #
  # @param [ActionController::Parameters] params parameters.
  # @return [ActionController::Parameters] params
  def update_password_params(params)
    params.permit(:password, :password_confirmation)
  end

  # Validate password is correct.
  #
  # @param [User] user user
  # @param [String] password password
  def correct_password?(user, password, field)
    unless user.authenticate(password)
      fail BadRequestError.new(code: :incorrect, field: field), "Incorrect password"
    end
  end
end

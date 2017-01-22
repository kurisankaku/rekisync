# Profile Service.
class ProfileService
  # Create a profile.
  #
  # @param [User] user the user who creates the profile.
  # @param [ActionController::Parameters] params parameters.
  # @return [Profile] profile.
  def create(user, params)
    profile = Profile.new(profile_params(params))
    profile.birthday_access_scope = AccessScope.find_by_code(params[:birthday_access_scope].try(:[], :code)) || AccessScope.find_by_code(:private)
    profile.country = Country.find_by_code(params[:country].try(:[], :code))
    profile.user = user
    profile.tap(&:save!)
  end

  # Update a profile.
  #
  # @param [Integer] id Profile id for updating.
  # @param [ActionController::Parameters] params parameters.
  # @return [Profile] profile.
  def update(id, params)
    profile = Profile.find_by_id(id)
    if profile.nil?
      fail BadRequestError.resource_not_found(:id), "Profile not found by id."
    end
    profile.country = Country.find_by_code(params[:country][:code]) if params[:country].try(:[], :code).present?

    birthday_access_scope = AccessScope.find_by_code(params[:birthday_access_scope].try(:[], :code))
    profile.birthday_access_scope = birthday_access_scope if birthday_access_scope.present?

    profile.update!(profile_params(params))
    profile
  end

  private

  # Sanitize params for profile save action.
  #
  # @param [ActionController::Parameters] params parameters.
  # @return [ActionController::Parameters] params.
  def profile_params(params)
    params.permit(
      :name,
      :about_me,
      :avator_image,
      :background_image,
      :birthday,
      :state_city,
      :street,
      :website,
      :google_plus,
      :facebook,
      :twitter
    )
  end
end

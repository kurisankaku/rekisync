module Settings
  # Profile controller.
  class ProfilesController < ApplicationController
    # Show the profile page.
    def show
      @profile = self.current_user.profile || Profile.new
    end

    # Show the profile new page.
    def new
      if self.current_user.profile.present?
        redirect_to :edit
      end
      @profile = Profile.new
    end

    # Create the profile.
    def create
      @error = execute_action do
        ProfileService.new.create(self.current_user, params)
      end

      if @error.present?
        @profile = Profile.new(params.except(:authenticity_token, :country, :controller, :action, :locale).permit!)
        @profile.country = Country.find_by_code(params[:country].try(:[], :code))
        render :new, status: 400
      else
        redirect_to settings_profile_url
      end
    end

    # Show the edit profile page.
    def edit
      @profile = self.current_user.profile
    end

    # Update the profile.
    def update
      @error = execute_action do
        ProfileService.new.update(self.current_user.profile.try(:id), params)
      end
      if @error.present?
        @profile = Profile.new(params.except(:authenticity_token, :country, :controller, :action, :locale).permit!)
        @profile.country = Country.find_by_code(params[:country].try(:[], :code))
        render :edit, status: 400
      else
        redirect_to settings_profile_url
      end
    end
  end
end

# Users controller.
class UsersController < ApplicationController
  def index
    @users = User.includes(:profile).all
  end
end

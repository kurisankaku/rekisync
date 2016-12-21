# Appliction controller.
class ApplicationController < ActionController::Base
  include Localable
  include Authenticatable
  protect_from_forgery with: :exception
end

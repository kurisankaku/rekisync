# Appliction controller.
class ApplicationController < ActionController::Base
  include Localable
  include Authenticatable
  include ErrorHandlable
  include LogPayloadable
  protect_from_forgery with: :exception
end

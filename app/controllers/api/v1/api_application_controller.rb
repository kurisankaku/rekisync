module Api
  module V1
    # Api Application Controller.
    class ApiApplicationController < ActionController::Base
      include ApiAuthenticatable
      include ApiErrorHandlable
    end
  end
end

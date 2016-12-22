# Authenticate module.
module ErrorHandlable
  extend ActiveSupport::Concern

  included do
    unless Rails.env.development?
      rescue_from Exception, with: :server_error
    end
    rescue_from UnAuthorizedError, with: :unauthorized_error
  end

  # Handle server error.
  def server_error(e = nil)
    logger.error "Rendering 500 with exception: #{e.message}" if e

    if request.xhr?
      render json: { error: '500 error' }, status: 500
    else
      render file: Rails.root.join('public/500.html'), status: 500, layout: false, content_type: 'text/html'
    end
  end

  # Handle unauthorized error.
  def unauthorized_error(e = nil)
    logger.error "Rendering 401 with exception: #{e.message}" if e

    if request.xhr?
      render json: { error: '401 error' }, status: 401
    else
      redirect_to login_index_path, alert: :unauthorized
    end
  end

  # Execute action.
  # Rescue error to display to page.
  #
  # @return [Hash] error.
  def execute_action
    errors = {}
    begin
      yield
    rescue ActiveRecord::RecordInvalid => e
      errors = e.record.errors.details
    rescue BadRequestError => e
      errors = e.format_views_error
    end
    errors
  end
end

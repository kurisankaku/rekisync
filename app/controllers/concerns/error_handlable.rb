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
    logger.fatal build_base_log(e, 500).to_json

    if request.xhr?
      render json: { error: '500 error' }, status: 500
    else
      render file: Rails.root.join('public/500.html'), status: 500, layout: false, content_type: 'text/html'
    end
  end

  # Handle unauthorized error.
  def unauthorized_error(e = nil)
    logger.error build_base_log(e, 401).to_json

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
    log = {}
    begin
      yield
    rescue ActiveRecord::RecordInvalid => e
      errors = e.record.errors.details
      logger.error build_base_log(e, 400).merge!(details: errors).to_json
    rescue BadRequestError => e
      logger.error build_base_log(e, e.status_code).to_json
      errors = e.format_views_error
    end
    errors
  end

  # Build base log by error.
  # @param [Error] e
  # @param [Integer] status
  # @return [Hash] log.
  def build_base_log(e, status)
    log = { log_type: "server", status: status }
    log.merge!(message: e.message, backtrace: e.backtrace.join("\n")) if e.present?
    log
  end
end

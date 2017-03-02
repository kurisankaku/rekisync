# Error Handlable module.
module ErrorHandlable
  extend ActiveSupport::Concern

  included do
    rescue_from Exception, with: :server_error unless Rails.env.development?
    rescue_from NotFoundPageError, with: :not_found_page_error
    rescue_from UnAuthorizedError, with: :unauthorized_error
  end

  # Handle server error.
  def server_error(e = nil)
    logger.fatal build_log(e, 500).to_json

    render file: Rails.root.join("public/500.html", status: 500, layout: false, content_type: "text/html")
  end

  # Handle unauthorized error.
  def unauthorized_error(e = nil)
    logger.error build_log(e, 401).to_json

    redirect_to login_index_path, alert: :unauthorized
  end

  # Handle not found page error.
  def not_found_page_error(e = nil)
    logger.error build_log(e, 404).to_json
    render file: Rails.root.join("public/404.html", status: 404, layout: false, content_type: "text/html")
  end

  # Execute action.
  # Rescue error to display to page.
  #
  # @return [Hash] error.
  def execute_action
    errors = {}
    ActiveRecord::Base.transaction do
      begin
        yield
      rescue ActiveRecord::RecordInvalid => e
        errors = e.record.errors.to_hash
        logger.error build_log(e, 400).merge!(details: errors).to_json
      rescue BadRequestError => e
        logger.error build_log(e, e.status_code).to_json
        errors = e.format_views_error
      end
    end
    errors
  end

  # Build base log by error.
  # @param [Error] e
  # @param [Integer] status
  # @return [Hash] log.
  def build_log(e, status)
    log = { log_type: "server", status: status, user_agent: request.try(:headers).try(:[], :HTTP_USER_AGENT), user_id: current_user.try(:id) }
    log.merge!(message: e.message, backtrace: e.backtrace.join("\n")) if e.present?
    log
  end
end

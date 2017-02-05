# Api Error Handlable module.
module ApiErrorHandlable
  extend ActiveSupport::Concern

  included do
    rescue_from Exception, with: :server_error
    rescue_from UnAuthorizedError, with: :unauthorized_error
  end

  # Handle server error.
  def server_error(e = nil)
    logger.fatal build_log(e, 500).to_json

    render json: { message: "ServerError", code: "server_error", errors: {} }, status: 500
  end

  # Handle unauthorized error.
  def unauthorized_error(e = nil)
    logger.error build_log(e, e.status_code).to_json

    render json: { message: "UnAuthorizedError", code: "unauthorize", errors: {} }, status: e.status_code
  end

  # Execute action.
  # Rescue error to display to page.
  #
  # @return [Hash] error.
  def execute_action
    ActiveRecord::Base.transaction do
      begin
        yield
      rescue ActiveRecord::RecordInvalid => e
        logger.error build_log(e, 400).merge!(details: e.record.errors.to_hash).to_json
        render json: { message: "RecordInvalid", code: "record_invalid", errors: e.record.errors.to_hash }, status: 400
      rescue BadRequestError => e
        logger.error build_log(e, e.status_code).to_json
        render json: { message: e.message, code: "bad_request", errors: e.format_api_error }, status: e.status_code
      end
    end
  end

  # Build base log by error.
  # @param [Error] e
  # @param [Integer] status
  # @return [Hash] log.
  def build_log(e, status)
    log = { log_type: "api_server", status: status, user_agent: request.try(:headers).try(:[], :HTTP_USER_AGENT), user_id: self.current_user.try(:id) }
    log.merge!(message: e.message, backtrace: e.backtrace.join("\n")) if e.present?
    log
  end
end

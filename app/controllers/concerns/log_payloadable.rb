module LogPayloadable
  # Apend log info to lograge.
  def append_info_to_payload(payload)
    super
    payload[:user_agent] = request.headers[:HTTP_USER_AGENT]
    payload[:user_id] = current_user.try(:id)
  end
end

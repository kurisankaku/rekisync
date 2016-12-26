Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.custom_options = lambda do |event|
    {
      time: event.time,
      user_agent: event.payload[:user_agent],
      user_id: event.payload[:user_id]
    }
  end
  config.lograge.formatter = Lograge::Formatters::Lines.new
end

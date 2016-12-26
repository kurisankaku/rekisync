class Logger
  # Custom logger.
  class
    CustomLogger < Formatter

    def call(severity, timestamp, _progname, msg)
      log = { level: severity, time: timestamp }
      begin
        message = JSON.parse(msg)
      rescue
        msg = msg.is_a?(String) ? msg : msg.inspect
        message = { message: msg }
      end
      log.merge!(message)
      log.to_json + "\n"
    end
  end
end

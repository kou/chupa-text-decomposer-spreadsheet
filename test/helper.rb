module Helper
  def fixture_path(*components)
    base_dir = File.expand_path(__dir__)
    File.join(base_dir, "fixture", *components)
  end

  class CaptureLogger
    def initialize(output)
      @output = output
    end

    def error(message=nil)
      @output << [:error, message || yield]
    end
  end

  def capture_log
    original_logger = ChupaText.logger
    begin
      output = []
      ChupaText.logger = CaptureLogger.new(output)
      yield
      normalize_log(output)
    ensure
      ChupaText.logger = original_logger
    end
  end

  def normalize_log(log)
    log.collect do |level, message|
      message = message.split("\n", 2)[0]
      [level, message]
    end
  end
end

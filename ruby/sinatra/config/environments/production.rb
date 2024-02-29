ActiveRecord::Base.logger = Logger.new($stdout)
ActiveRecord::Base.logger.formatter = proc do |_severity, _datetime, _progname, message|
  "#{message}\n"
end

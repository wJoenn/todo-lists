ActiveRecord::Base.establish_connection(ENV["RACK_ENV"].to_sym)

ActiveRecord::Base.logger = Logger.new($stdout)
ActiveRecord::Base.logger.formatter = proc do |_severity, _datetime, _progname, message|
  "#{message}\n"
end

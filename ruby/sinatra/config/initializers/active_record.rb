ActiveRecord::Base.establish_connection(ENV["RAKE_ENV"].to_sym)

if ENV["RAKE_ENV"] != "test"
  ActiveRecord::Base.logger = Logger.new($stdout)
  ActiveRecord::Base.logger.formatter = proc do |_severity, _datetime, _progname, message|
    "#{message}\n"
  end
end

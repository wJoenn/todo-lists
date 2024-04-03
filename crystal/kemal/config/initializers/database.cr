# require "colorize"
require "jennifer"
require "jennifer/adapter/postgres"
require "jennifer/adapter/db_colorized_formatter"

# struct DBFormatter < Log::StaticFormatter
#   def run
#     latency = @entry.data[:time].as_f64.fdiv(1000).round(2)
#     @io << "(#{latency}ms)  ".colorize(:light_cyan)

#     query = @entry.data[:query].as_s
#     @io << colorized_query(query)

#     args = @entry.data[:args]?.try &.as_a
#     @io << "  [#{args}]" if args && !args.empty?
#   end

#   private def colorized_query(query)
#     color = case query.split.first
#             when "DELETE" then :light_red
#             when "INSERT" then :light_green
#             when "SELECT" then :light_blue
#             when "UPDATE" then :light_yellow
#             else               :light_magenta
#             end

#     query.colorize(color)
#   end
# end

Jennifer::Config.configure do |conf|
  if ENV.has_key?("DATABASE_URL")
    conf.from_uri(ENV["DATABASE_URL"])
  else
    conf.read("config/database.yml", ENV["KEMAL_ENV"])
  end
end

if ENV["KEMAL_ENV"] == "test"
  Log.setup "db", Log::Severity::None, Log::IOBackend.new

  Jennifer::Config.configure do |conf|
    conf.verbose_migrations = false
  end
else
  Log.setup "db", Log::Severity::Debug, Log::IOBackend.new(formatter: Jennifer::Adapter::DBColorizedFormatter)
end

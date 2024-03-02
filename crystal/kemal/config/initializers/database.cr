require "colorize"
require "jennifer"
require "jennifer/adapter/postgres"

ENV["KEMAL_ENV"] ||= "development"

struct DBFormatter < Log::StaticFormatter
  def run
    @io << "(#{@entry.data[:time].as_f64.fdiv(1000).round(2)}ms)  ".colorize(:light_cyan)

    query = @entry.data[:query].as_s
    @io << colorized_query(query)

    args = @entry.data[:args]?.try &.as_a
    @io << "  [#{args}]" if args.present? && !args.try &.empty?
  end

  private def colorized_query(query)
    color = case query.split.first
            when "DELETE" then :light_red
            when "INSERT" then :light_green
            when "SELECT" then :light_blue
            when "UPDATE" then :light_yellow
            else               :light_magenta
            end

    query.colorize(color)
  end
end

Jennifer::Config.configure do |conf|
  conf.read("config/database.yml", ENV["KEMAL_ENV"])
  conf.from_uri(ENV["DATABASE_URI"]) if ENV.has_key?("DATABASE_URI")

  levels = {
    "development": Log::Severity::Debug,
    "production":  Log::Severity::Error,
    "test":        Log::Severity::None,
  }

  conf.logger = Log.for("db")
  conf.logger.level = levels[ENV["KEMAL_ENV"]]
  # conf.logger.backend = Log::IOBackend.new(formatter: Jennifer::Adapter::DBFormatter)
  conf.logger.backend = Log::IOBackend.new(formatter: DBFormatter)
end

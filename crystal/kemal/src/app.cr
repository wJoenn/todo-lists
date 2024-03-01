require "kemal"
require "../config/config"

Kemal.config.host_binding = "::1"

get "/" do
  Task.all.to_json
end

Kemal.run

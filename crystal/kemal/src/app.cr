require "kemal"
require "../config/config"

Kemal.config.host_binding = "::1"

get "/" do
  "Hello World!"
end

Kemal.run

require "kemal"

Kemal.config.host_binding = "::1"

get "/" do
  "Hello World!"
end

Kemal.run

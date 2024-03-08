class CorsHandler < Kemal::Handler
  def call(env : HTTP::Server::Context)
    env.response.headers["Access-Control-Allow-Origin"] = "*"
    env.response.headers["Access-Control-Expose-Headers"] = "Authorization"

    if cors?(env.request)
      env.response.headers["Access-Control-Allow-Methods"] = "GET, HEAD, POST, PUT, PATCH, DELETE, OPTIONS"
      env.response.headers["Access-Control-Allow-Headers"] = "Content-Type, Authorization"
      return
    end

    call_next env
  end

  private def cors?(request : HTTP::Request) : Bool
    options?(request) && has_origin?(request) && has_access_control_request_method?(request)
  end

  private def has_access_control_request_method?(request : HTTP::Request) : Bool
    request.headers.has_key?("access-control-request-method")
  end

  private def has_origin?(request : HTTP::Request) : Bool
    request.headers.has_key?("origin")
  end

  private def options?(request : HTTP::Request) : Bool
    request.method == "OPTIONS"
  end
end

add_handler CorsHandler.new

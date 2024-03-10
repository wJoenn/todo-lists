require "sinatra/cross_origin"

class CorsHandler
  class << self
    def call(env, response)
      response.headers["Access-Control-Allow-Origin"] = "*"
      response.headers["Access-Control-Expose-Headers"] = "Authorization"

      if cors?(env)
        response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-type"
        response.headers["Access-Control-Allow-Methods"] = "GET, PUT, PATCH, POST, DELETE, OPTIONS, HEAD"
      end
    end

    private

    def cors?(env)
      options?(env) && has_origin?(env) && has_access_control_request_method?(env)
    end

    def has_access_control_request_method?(env)
      env.has_key("HTTP_ACCESS_CONTROL_REQUEST_METHOD")
    end

    def has_origin?(env)
      env.has_key("HTTP_ORIGIN")
    end

    def options?(env)
      env["REQUEST_METHOD"] == "OPTIONS"
    end
  end
end

configure do
  enable :cross_origin
end

before do
  CorsHandler.call(env, response)
end

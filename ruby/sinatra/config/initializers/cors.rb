require "sinatra/cross_origin"

class CorsHandler
  class << self
    def call(request, response)
      response.headers["Access-Control-Allow-Origin"] = "*"
      response.headers["Access-Control-Expose-Headers"] = "Authorization"

      if cors?(request)
        response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-type"
        response.headers["Access-Control-Allow-Methods"] = "GET, PUT, PATCH, POST, DELETE, OPTIONS, HEAD"
      end
    end

    private

    def cors?(request)
      options?(request) && has_origin?(request) && has_access_control_request_method?(request)
    end

    def has_access_control_request_method?(request)
      request.env.has_key("HTTP_ACCESS_CONTROL_REQUEST_METHOD")
    end

    def has_origin?(request)
      request.env.has_key("HTTP_ORIGIN")
    end

    def options?(request)
      request.env["REQUEST_METHOD"] == "OPTIONS"
    end
  end
end

configure do
  enable :cross_origin
end

before do
  CorsHandler.call(request, response)
end

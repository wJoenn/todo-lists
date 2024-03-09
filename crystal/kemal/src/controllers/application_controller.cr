class ApplicationController
  def self.authenticate?(env : HTTP::Server::Context)
    jwt = env.request.headers["AUTHORIZATION"]?
    if jwt && (user = User.by_jwt(jwt))
      return new(env, user)
    end

    env.response.respond_with_status 401
  end

  def initialize(@env : HTTP::Server::Context, @current_user = User.new)
  end

  private def current_user
    @current_user
  end

  private def params
    @params ||= @env.params.as Kemal::ParamParser
  end

  private def response
    @response ||= @env.response
  end
end

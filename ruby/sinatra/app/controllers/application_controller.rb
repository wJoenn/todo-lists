class ApplicationController
  def initialize(env, current_user = nil)
    @env = env
    @current_user = current_user
  end

  private

  attr_reader :current_user

  def params
    @params ||= begin
      data = @env.request.body.read
      params = (data.present? ? JSON.parse(data) : @env.request.params["params"]) || {}

      JSON.parse(params.merge(@env.request.params).to_json, symbolize_names: true)
    end
  end

  def response
    @response ||= @env.response
  end

  class << self
    def authenticate(env)
      jwt = env["HTTP_AUTHORIZATION"]
      user = User.by_jwt(jwt)
      return new(env, user) if user.present?

      env.response.status = 401
      nil
    end
  end
end

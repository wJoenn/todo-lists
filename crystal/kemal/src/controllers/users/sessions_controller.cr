class Users::SessionsController < ApplicationController
  def create
    user = User.where({:email => user_params[:email]}).limit(1).first

    if user && (password = user_params[:password]) && user.authenticate(password)
      response.status_code = 200
      response.headers["Authorization"] = user.as(User).jwt
      return user.to_json
    end

    response.status_code = 401
    {errors: ["Invalid Email or Password"]}.to_json
  end

  def destroy
    current_user.edit_jti
    current_user.save
    response.status_code = 200
  end

  private def user_params : NamedTuple
    user_params = params.json["user"].as Hash

    {email: user_params["email"]?.try &.as_s?, password: user_params["password"]?.try &.as_s?}
  end
end

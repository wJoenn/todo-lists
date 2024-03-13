class Users::RegistrationsController < ApplicationController
  def show
    response.status_code = 200
    current_user.to_json
  end

  def create
    user = User.new({:email => user_params[:email]})
    user.password = user_params[:password]
    user.password_confirmation = user_params[:password_confirmation]

    if user.save
      response.status_code = 201
      response.headers["Authorization"] = user.jwt
      return user.to_json
    end

    response.status_code = 422
    {errors: user_errors(user)}.to_json
  end

  private def user_errors(user) : Hash
    errors = user.errors
    errors.messages.map { |attribute, message| [attribute, errors.full_message(attribute, message.first)] }.to_h
  end

  private def user_params : NamedTuple
    user_params = params.json["user"].as Hash

    {
      email:                 user_params["email"]?.try &.as_s?,
      password:              user_params["password"]?.try &.as_s?,
      password_confirmation: user_params["password_confirmation"]?.try &.as_s?,
    }
  end
end

module Users
  class SessionsController < ApplicationController
    def create
      user = User.find_by(email: user_params[:email])

      if user.present? && user.password == user_params[:password]
        response.status = 200
        response.headers["Authorization"] = user.jwt
        user.to_json
      else
        response.status = 401
        { errors: ["Invalid Email or Password"] }.to_json
      end
    end

    def destroy
      current_user.edit_jti
      current_user.save
      response.status = 200
    end

    private

    def user_params
      params[:user]&.slice(:email, :password) || {}
    end
  end
end

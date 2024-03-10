module Users
  class RegistrationsController < ApplicationController
    def show
      response.status = 200
      current_user.to_json
    end

    def create
      user = User.new(user_params)

      if user.save
        response.status = 201
        response.headers["Authorization"] = user.jwt
        user.to_json
      else
        response.status = 422
        { errors: user.errors.full_messages }.to_json
      end
    end

    private

    def user_params
      params[:user]&.slice(:email, :password, :password_confirmation) || {}
    end
  end
end

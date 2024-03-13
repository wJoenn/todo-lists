module Users
  class RegistrationsController < ApplicationController
    def show
      response.status = 200
      current_user.to_json
    end

    def create
      @user = User.new(user_params)

      if @user.save
        response.status = 201
        response.headers["Authorization"] = @user.jwt
        @user.to_json
      else
        response.status = 422
        { errors: user_errors }.to_json
      end
    end

    private

    def user_errors
      errors = @user.errors.map { |error| [error.attribute, error.full_message] }.to_h
      errors[:password] = errors.delete(:base)

      errors
    end

    def user_params
      params[:user]&.slice(:email, :password, :password_confirmation) || {}
    end
  end
end

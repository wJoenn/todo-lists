class Users::CurrentUserController < ApplicationController
  def index
    render json: current_user.serialize, status: :ok
  end
end

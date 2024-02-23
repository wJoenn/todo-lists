class Users::CurrentUserController < ApplicationController
  def index
    render json: { user: current_user.serialize }, status: :ok
  end
end

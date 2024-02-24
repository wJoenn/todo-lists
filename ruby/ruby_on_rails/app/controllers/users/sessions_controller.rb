class Users::SessionsController < Devise::SessionsController
  skip_before_action :verify_signed_out_user

  def create
    self.resource = warden.authenticate(auth_options)

    if resource.present?
      sign_in(resource_name, resource)
      render json: { user: resource.serialize }, status: :ok
    else
      render json: { errors: ["Invalid Email or Password"] }, status: :unauthorized
    end
  end

  def destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    render status: :ok
  end
end

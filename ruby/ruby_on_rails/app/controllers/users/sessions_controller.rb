class Users::SessionsController < Devise::SessionsController
  def create
    self.resource = warden.authenticate(auth_options)

    if self.resource.present?
      sign_in(resource_name, resource)
      yield resource if block_given?
      render json: { user: resource.serialize }, status: :ok
    else
      render json: { errors: ["Invalid Email or Password"] }, status: :unauthorized
    end
  end

  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    yield if block_given?
    render status: :ok
  end
end

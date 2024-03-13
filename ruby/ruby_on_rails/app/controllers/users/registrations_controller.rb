class Users::RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(sign_up_params)

    if resource.save
      sign_in(resource_name, resource)
      render json: resource, status: :created
    else
      render json: {
        errors: resource.errors.map { |error| [error.attribute, error.full_message] }.to_h
      }, status: :unprocessable_entity
    end
  end
end

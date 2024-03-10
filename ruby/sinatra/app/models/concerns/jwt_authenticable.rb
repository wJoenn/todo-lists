module JwtAuthenticable
  extend ActiveSupport::Concern

  included do
    filter_attributes << :jti

    before_create :edit_jti
  end

  def edit_jti
    self.jti = Bearer.jti
  end

  def jwt
    Bearer.encode(jti)
  end

  def to_json
    as_json.except(*self.class.filter_attributes.map(&:to_s)).to_json
  end

  class_methods do
    def by_jwt(jwt)
      jti = Bearer.decode(jwt)
      find_by(jti:)
    end
  end
end

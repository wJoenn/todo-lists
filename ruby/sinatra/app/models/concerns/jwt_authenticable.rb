module JwtAuthenticable
  extend ActiveSupport::Concern

  included do
    self.filter_attributes = %i[encrypted_password jti]

    attr_accessor :password_confirmation

    validate :password_presence
    validate :password_confirmation_matches_password

    before_create :edit_jti
  end

  def edit_jti
    self.jti = Bearer.jti
  end

  def jwt
    Bearer.encode(jti)
  end

  def password
    BCrypt::Password.new(encrypted_password)
  end

  def password=(new_password)
    self.encrypted_password = BCrypt::Password.create(new_password)
  end

  def to_json
    as_json.except(*self.class.filter_attributes.map(&:to_s)).to_json
  end

  private

  def password_confirmation_matches_password
    if password_confirmation.present? && password != password_confirmation
      errors.add(:base, "Password confirmation doesn't match Password")
    end
  end

  def password_presence
    errors.add(:base, "Password can't be blank") if encrypted_password.blank?
  end

  class_methods do
    def by_jwt(jwt)
      jti = Bearer.decode(jwt)

      find_by(jti:)
    end
  end
end

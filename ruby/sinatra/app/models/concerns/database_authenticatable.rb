module DatabaseAuthenticable
  extend ActiveSupport::Concern

  included do
    filter_attributes << :encrypted_password

    attr_accessor :password_confirmation

    validate :password_presence
    validate :password_confirmation_matches_password
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
end

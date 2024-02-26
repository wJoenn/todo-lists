class User < ActiveRecord::Base
  attr_accessor :password, :password_confirmation

  validates :email, presence: true, format: { with: /\A[^@\s]+@[^@\s]+\.[a-z]{2,}\z/, allow_blank: true }
  validate :password_presence
  validate :password_confirmation_matches_password

  before_save :set_encrypted_password

  private

  def password_confirmation_matches_password
    if password_confirmation.present? && password != password_confirmation
      errors.add(:base, "Password confirmation doesn't match Password")
    end
  end

  def password_presence
    errors.add(:base, "Password can't be blank") if password.blank?
  end

  def set_encrypted_password
    return if password.blank?

    self.encrypted_password = BCrypt::Password.create(password)
  end
end

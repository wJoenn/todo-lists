class User < ActiveRecord::Base
  attr_accessor :password_confirmation

  has_many :tasks

  validates :email, presence: true, format: { with: /\A[^@\s]+@[^@\s]+\.[a-z]{2,}\z/, allow_blank: true }
  validate :password_presence
  validate :password_confirmation_matches_password

  before_create :set_jti

  def jwt
    Bearer.encode(jti)
  end

  def password
    BCrypt::Password.new(encrypted_password)
  end

  def password=(new_password)
    self.encrypted_password = BCrypt::Password.create(new_password)
  end

  def set_jti
    self.jti = Bearer.create_jti
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

  class << self
    def by_jti(jwt)
      jti = Bearer.decode(jwt)

      find_by(jti:)
    end
  end
end

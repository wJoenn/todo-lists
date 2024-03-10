class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, :recoverable, :rememberable,  and :omniauthable
  devise :database_authenticatable, :registerable, :validatable,
    :jwt_authenticatable, jwt_revocation_strategy: self

  UNSAFE_ATTRIBUTES_FOR_SERIALIZATION << :jti

  has_many :tasks, dependent: :destroy

  def serialize
    {
      id: id,
      email: email
    }
  end
end

class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, :recoverable, :rememberable,  and :omniauthable
  devise :database_authenticatable, :registerable, :validatable,
    :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :tasks, dependent: :destroy

  def serialize
    {
      id: self.id,
      email: self.email
    }
  end
end

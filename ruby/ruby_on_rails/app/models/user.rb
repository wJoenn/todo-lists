class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, :recoverable, :rememberable,  and :omniauthable
  devise :database_authenticatable, :registerable, :validatable

  has_many :tasks, dependent: :destroy
end

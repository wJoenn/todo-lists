class User < ActiveRecord::Base
  include DatabaseAuthenticable
  include JwtAuthenticable

  has_many :tasks

  validates :email, presence: true, format: { with: /\A[^@\s]+@[^@\s]+\.[a-z]{2,}\z/, allow_blank: true }
end

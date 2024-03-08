require "jennifer/model/authentication"

class User < Jennifer::Model::Base
  include Jennifer::Model::Authentication

  with_authentication
  with_timestamps

  mapping(
    id: Primary32,
    email: String?,
    password_digest: {type: String, default: ""},
    password: Password,
    password_confirmation: {type: String?, virtual: true},
    jti: {type: String, default: Bearer.create_jti},
    created_at: Time?,
    updated_at: Time?,
  )

  has_many :tasks, Task, dependent: :destroy

  validates_presence :email
  validates_format :email, /\A[^@\s]+@[^@\s]+\.[a-z]{2,}\z/, allow_blank: true
  validates_with_method :jti_presence

  def self.by_jwt(jwt : String) : User | Nil
    jti = Bearer.decode(jwt)

    where({:jti => jti}).limit(1).first
  end

  def edit_jti
    self.jti = Bearer.create_jti
  end

  def jwt : String
    Bearer.encode(jti)
  end

  private def jti_presence
    edit_jti if jti.nil?
  end
end

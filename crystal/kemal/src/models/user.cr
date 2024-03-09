require "jennifer/model/authentication"

class User < Jennifer::Model::Base
  include Jennifer::Model::Authentication

  FILTERED_KEYS = %i[jti password password_digest password_confirmation]

  with_authentication
  with_timestamps

  mapping(
    id: Primary32,
    email: String?,
    password_digest: {type: String, default: ""},
    password: Password,
    password_confirmation: {type: String?, virtual: true},
    jti: {type: String, default: Bearer.jti},
    created_at: Time?,
    updated_at: Time?,
  )

  has_many :tasks, Task, dependent: :destroy

  validates_presence :email
  validates_format :email, /\A[^@\s]+@[^@\s]+\.[a-z]{2,}\z/, allow_blank: true

  def self.by_jwt(jwt : String) : User?
    jti = Bearer.decode(jwt)

    where({:jti => jti}).limit(1).first
  end

  def edit_jti
    self.jti = Bearer.jti
  end

  def jwt : String
    Bearer.encode(jti)
  end

  def to_json : String
    to_h.reject(FILTERED_KEYS).to_json
  end
end

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
    created_at: Time?,
    updated_at: Time?,
  )

  validates_presence :email
  validates_format :email, /\A[^@\s]+@[^@\s]+\.[a-z]{2,}\z/, allow_blank: true
end

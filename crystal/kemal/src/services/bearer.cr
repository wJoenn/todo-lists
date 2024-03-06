require "jwt"
require "uuid"

class Bearer
  def self.decode(bearer_token : String) : String | Nil
    jwt = bearer_token.gsub(/^Bearer /, "")
    payload, _ = JWT.decode jwt, ENV["JWT_SECRET_KEY"], JWT::Algorithm::HS256

    payload["jti"].as_s
  rescue
    nil
  end

  def self.encode(jti : String) : String
    payload = {"jti" => jti}
    jwt = JWT.encode payload, ENV["JWT_SECRET_KEY"], JWT::Algorithm::HS256
    "Bearer #{jwt}"
  end

  def self.create_jti : String
    UUID.random.to_s
  end
end

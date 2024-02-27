class Bearer
  class << self
    def decode(bearer_token)
      jwt = bearer_token.gsub(/^Bearer /, "")
      jti, _ = JWT.decode jwt, ENV["JWT_SECRET_KEY"], true, { algorithm: "HS256" }
      jti
    rescue
      nil
    end

    def encode(jti)
      jwt = JWT.encode jti, ENV["JWT_SECRET_KEY"], "HS256"
      "Bearer #{jwt}"
    end

    def create_jti
      SecureRandom.uuid
    end
  end
end

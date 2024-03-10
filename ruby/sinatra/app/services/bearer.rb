class Bearer
  class << self
    def decode(bearer_token)
      jwt = bearer_token.gsub(/^Bearer /, "")
      payload, _ = JWT.decode jwt, ENV["JWT_SECRET_KEY"], true, { algorithm: "HS256" }

      payload["jti"]
    rescue
      nil
    end

    def encode(jti)
      payload = { jti: }
      jwt = JWT.encode payload, ENV["JWT_SECRET_KEY"], "HS256"

      "Bearer #{jwt}"
    end

    def jti
      SecureRandom.uuid
    end
  end
end

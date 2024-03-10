require "../spec_helper"

describe Bearer do
  jti = Bearer.jti
  bearer = Bearer.encode(jti)

  describe ".decode" do
    it "decodes a Json Web Token into a jti" do
      Bearer.decode(bearer).should eq jti
    end

    it "returns nil when a JWT::VerificationError is triggered" do
      Bearer.decode("#{bearer[0...]}a").should be_nil
    end

    it "returns nil when a JWT::DecodeError is triggered" do
      Bearer.decode("not a bearer token").should be_nil
    end
  end

  describe ".encode" do
    it "encodes a jti into a Json Web Token" do
      bearer.should match /^Bearer \w+/
    end

    it "adds an expiration date of 30 days" do
      jwt = bearer.gsub(/^Bearer /, "")
      payload, _ = JWT.decode jwt, ENV["JWT_SECRET_KEY"], JWT::Algorithm::HS256

      Time.unix(payload["exp"].as_i64).date.should eq 30.days.from_now.date
    end
  end

  describe ".jti" do
    it "creates random Json Web Token ids" do
      jtis = (1..100).map { |_| Bearer.jti }.uniq!
      jtis.size.should eq 100
    end
  end
end

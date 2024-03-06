require "../spec_helper"

describe Bearer do
  jti = Bearer.create_jti
  bearer = Bearer.encode(jti)

  describe "::decode" do
    it "decodes a Json Web Token into a jti" do
      decoded_bearer = Bearer.decode(bearer)
      decoded_bearer.should eq jti
    end

    it "returns nil when a JWT::VerificationError is triggered" do
      decoded_bearer = Bearer.decode("#{bearer[0...]}a")
      decoded_bearer.should be_nil
    end

    it "returns nil when a JWT::DecodeError is triggered" do
      decoded_bearer = Bearer.decode("not a bearer token")
      decoded_bearer.should be_nil
    end
  end

  describe "::encode" do
    it "encodes a jti into a Json Web Token" do
      bearer.should match /^Bearer \w+/
    end
  end

  describe "::create_jti" do
    it "creates random Json Web Token ids" do
      jtis = (1..100).map { |_| Bearer.create_jti }.uniq!
      jtis.size.should eq 100
    end
  end
end

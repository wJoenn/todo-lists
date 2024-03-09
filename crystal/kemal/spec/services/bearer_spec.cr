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
  end

  describe ".jti" do
    it "creates random Json Web Token ids" do
      jtis = (1..100).map { |_| Bearer.jti }.uniq!
      jtis.size.should eq 100
    end
  end
end

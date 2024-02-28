require_relative "../sinatra_helper"

RSpec.describe Bearer, type: :service do
  let(:jti) { described_class.create_jti }
  let(:bearer) { described_class.encode(jti) }

  describe "::decode" do
    it "decodes a Json Web Token into a jti" do
      decoded_bearer = described_class.decode(bearer)
      expect(decoded_bearer).to eq jti
    end

    it "returns nil when a JWT::VerificationError is triggered" do
      decoded_bearer = described_class.decode("#{bearer[0...]}a")
      expect(decoded_bearer).to be_nil
    end

    it "returns nil when a JWT::DecodeError is triggered" do
      decoded_bearer = described_class.decode("not a bearer token")
      expect(decoded_bearer).to be_nil
    end
  end

  describe "::encode" do
    it "encodes a jti into a Json Web Token" do
      expect(bearer).to match(/^Bearer \w+/)
    end
  end

  describe "::create_jti" do
    it "creates random Json Web Token ids" do
      jtis = (1..100).map { |_| described_class.create_jti }.uniq
      expect(jtis.length).to be 100
    end
  end
end

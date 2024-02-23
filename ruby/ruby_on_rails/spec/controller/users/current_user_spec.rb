require 'rails_helper'

RSpec.describe "Users::CurrentUsers", type: :request do
  describe "GET /current_user" do
    context "with a valid JSON Web Token" do
      let(:user) { create(:user) }

      let(:jwt_token) do
        token = { sub: user.id, scp: "user", aud: nil, iat: Time.current.to_i, exp: 1.month.from_now.to_i, jti: user.jti }
        JWT.encode(token, Rails.application.credentials.devise_jwt_secret_key!)
      end

      before do
        get "/current_user", headers: { Authorization: "Bearer #{jwt_token}" }
      end

      it "returns a JSON object" do
        expect(response.body).to be_a String
        expect(response.parsed_body).to have_key "user"
      end

      it "returns the instance of User" do
        data = response.parsed_body
        expect(data.dig("user", "email")).to eq user.email
      end

      it "returns a HTTP status of ok" do
        expect(response).to have_http_status :ok
      end
    end

    context "without a valid JSON Web Token" do
      it "returns a HTTP status of ok" do
        get "/current_user"
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end

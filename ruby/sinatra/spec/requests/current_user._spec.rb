require "sinatra_helper"

RSpec.describe "/current_user", type: :request do
  describe "GET /current_user" do
    context "with a valid JSON Web Token" do
      let(:user) { User.create(email: "user@example.com", password: "password") }

      before do
        get "/current_user", nil, { "HTTP_AUTHORIZATION" => user.jwt }
      end

      it "returns a JSON object" do
        expect(last_response.body).to be_a String
        expect(JSON.parse(last_response.body)).to have_key "id"
      end

      it "returns the instance of User" do
        data = JSON.parse(last_response.body)
        expect(data["email"]).to eq user.email
      end

      it "returns a HTTP status of ok" do
        expect(last_response.status).to be 200
      end
    end

    context "without a valid JSON Web Token" do
      it "returns a HTTP status of ok" do
        get "/current_user"
        expect(last_response.status).to be 401
      end
    end
  end
end

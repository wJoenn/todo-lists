require "rails_helper"

RSpec.describe Users::SessionsController, type: :request do
  let(:user) { create(:user) }

  describe "POST /users/sign_in" do
    context "with proper params" do
      before do
        post "/users/sign_in", params: { user: { email: user.email, password: user.password } }
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

    context "without proper params" do
      before do
        post "/users/sign_in"
      end

      it "returns a JSON object" do
        expect(response.body).to be_a String
        expect(response.parsed_body).to have_key "errors"
      end

      it "returns a list of error messages" do
        data = response.parsed_body
        expect(data["errors"]).to contain_exactly "Invalid Email or Password"
      end

      it "returns a HTTP status of unauthorized" do
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe "DELETE /users/sign_out" do
    before do
      sign_in user
      delete "/users/sign_out"
    end

    it "signs the User out" do
      get "/tasks"
      expect(response).to have_http_status :unauthorized
    end

    it "returns a HTTP status of ok" do
      expect(response).to have_http_status :ok
    end
  end
end

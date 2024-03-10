RSpec.describe "Users::CurrentUsers", type: :request do
  describe "GET /current_user" do
    context "when a User is authenticated" do
      let(:user) { create(:user) }
      let(:jwt) do
        token = { jti: user.jti, scp: "user", sub: user.id }
        JWT.encode(token, Rails.application.credentials.devise_jwt_secret_key!)
      end

      before do
        get "/current_user", headers: { Authorization: "Bearer #{jwt}" }
      end

      it "returns a JSON object" do
        expect(response.body).to be_a String
        expect(response.parsed_body).to have_key "id"
      end

      it "returns the instance of User" do
        data = response.parsed_body
        expect(data["id"]).to eq user.id
      end

      it "returns a ok HTTP status" do
        expect(response).to have_http_status :ok
      end
    end

    context "when a User is not authenticated" do
      it "returns a unauthorized HTTP status" do
        get "/current_user"
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end

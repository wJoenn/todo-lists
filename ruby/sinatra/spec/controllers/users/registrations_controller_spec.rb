RSpec.describe Users::RegistrationsController, type: :request do
  describe "GET /current_user" do
    context "when a User is authenticated" do
      let(:user) { create(:user) }

      before do
        get "/current_user", nil, { "HTTP_AUTHORIZATION" => user.jwt }
      end

      it "returns a JSON object" do
        expect(last_response.body).to be_a String
        expect(JSON.parse(last_response.body)).to have_key "id"
      end

      it "returns the instance of User" do
        data = JSON.parse(last_response.body)
        expect(data["id"]).to eq user.id
      end

      it "returns a ok HTTP status" do
        expect(last_response.status).to be 200
      end
    end

    context "when a User is not authenticated" do
      it "returns a unauthorized HTTP status" do
        get "/current_user"
        expect(last_response.status).to be 401
      end
    end
  end

  describe "POST /users" do
    let(:email) { "user@example.com" }
    let(:password) { "password" }

    context "with proper params" do
      before do
        post "/users", params: { user: { email:, password:, password_confirmation: password } }
      end

      it "returns a JSON object" do
        expect(last_response.body).to be_a String
        expect(JSON.parse(last_response.body)).to have_key "id"
      end

      it "creates an instance of User" do
        expect(User.count).to eq 1
      end

      it "returns the new instance of User" do
        data = JSON.parse(last_response.body)
        expect(data["email"]).to eq email
      end

      it "returns a created HTTP status" do
        expect(last_response.status).to be 201
      end

      it "returns a Authorization header" do
        expect(last_response["Authorization"]).to eq User.first.jwt
      end
    end

    context "without proper params" do
      before do
        post "/users", params: { user: { email: nil, password: nil } }
      end

      it "returns a JSON object" do
        expect(last_response.body).to be_a String
        expect(JSON.parse(last_response.body)).to have_key "errors"
      end

      it "does not create an instance of User" do
        expect(User.count).to eq 0
      end

      it "returns a list of error messages" do
        data = JSON.parse(last_response.body)
        expect(data["errors"]).to contain_exactly("Email can't be blank", "Password can't be blank")
      end

      it "returns a HTTP status of unprocessable_entity" do
        expect(last_response.status).to be 422
      end
    end
  end
end

RSpec.describe "/users" do
  let(:email) { "user@example.com" }
  let(:password) { "password" }

  describe "POST /users" do
    context "with proper params" do
      before do
        post "/users", params: {
          user: {
            email:,
            password:,
            password_confirmation: password
          }
        }
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

      it "returns a HTTP status of created" do
        expect(last_response.status).to be 202
      end

      it "returns a Authorization header" do
        expect(last_response["Authorization"]).to be_present
      end
    end

    context "without proper params" do
      before do
        post "/users"
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

  describe "POST /users/sign_in" do
    let!(:user) { create(:user) }

    context "with proper params" do
      before do
        post "/users/sign_in", params: { user: { email:, password: } }
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

      it "returns a Authorization header" do
        expect(last_response["Authorization"]).to be_present
      end
    end

    context "without proper params" do
      before do
        post "/users/sign_in"
      end

      it "returns a JSON object" do
        expect(last_response.body).to be_a String
        expect(JSON.parse(last_response.body)).to have_key "errors"
      end

      it "returns a list of error messages" do
        data = JSON.parse(last_response.body)
        expect(data["errors"]).to contain_exactly "Invalid Email or Password"
      end

      it "returns a HTTP status of unauthorized" do
        expect(last_response.status).to be 401
      end
    end
  end

  describe "DELETE /users/sign_out" do
    let(:user) { create(:user) }

    before do
      delete "/users/sign_out", nil, { "HTTP_AUTHORIZATION" => user.jwt }
    end

    it "signs the User out" do
      get "/current_user", nil, { "HTTP_AUTHORIZATION" => user.jwt }
      expect(last_response.status).to be 401
    end

    it "returns a HTTP status of ok" do
      expect(last_response.status).to be 200
    end
  end
end

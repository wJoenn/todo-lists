RSpec.describe Users::SessionsController, type: :request do
  let(:user) { create(:user) }

  describe "POST /users/sign_in" do
    context "with proper params" do
      before do
        post "/users/sign_in", params: { user: { email: user.email, password: user.password } }
      end

      it "returns a JSON object" do
        expect(response.body).to be_a String
        expect(response.parsed_body).to have_key "id"
      end

      it "returns the instance of User" do
        data = response.parsed_body
        expect(data["id"]).to be user.id
      end

      it "returns a ok HTTP status" do
        expect(response).to have_http_status :ok
      end

      it "returns a Authorization header" do
        expect(response["Authorization"]).to match(/^Bearer .+/)
      end
    end

    context "without proper params" do
      before do
        post "/users/sign_in", params: { user: { email: nil, password: nil } }
      end

      it "returns a JSON object" do
        expect(response.body).to be_a String
        expect(response.parsed_body).to have_key "errors"
      end

      it "returns a list of error messages" do
        data = response.parsed_body
        expect(data["errors"]).to match({ user: "Invalid Email or Password" })
      end

      it "returns a unauthorized HTTP status" do
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe "DELETE /users/sign_out" do
    context "when a User is authenticated" do
      before do
        sign_in user
        delete "/users/sign_out"
      end

      it "signs the User out" do
        get "/current_user"
        expect(response).to have_http_status :unauthorized
      end

      it "returns a ok HTTP status" do
        expect(response).to have_http_status :ok
      end
    end

    context "when a User is not authenticated" do
      it "returns a unauthorized HTTP status" do
        delete "/users/sign_out"

        expect(response).to have_http_status :unauthorized
      end
    end
  end
end

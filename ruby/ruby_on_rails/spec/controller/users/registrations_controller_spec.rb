require "rails_helper"

RSpec.describe Users::RegistrationsController, type: :request do
  describe "POST /users" do
    context "with proper params" do
      let(:email) { "user@example.com" }

      before do
        post "/users", params: {
          user: {
            email:,
            password: "foobar",
            password_confirmation: "foobar"
          }
        }
      end

      it "returns a JSON object" do
        expect(response.body).to be_a String
        expect(response.parsed_body).to have_key "id"
      end

      it "creates an instance of User" do
        expect(User.count).to eq 1
      end

      it "returns the new instance of User" do
        data = response.parsed_body
        expect(data["email"]).to eq email
      end

      it "returns a HTTP status of created" do
        expect(response).to have_http_status :created
      end
    end

    context "without proper params" do
      before do
        post "/users"
      end

      it "returns a JSON object" do
        expect(response.body).to be_a String
        expect(response.parsed_body).to have_key "errors"
      end

      it "does not create an instance of User" do
        expect(User.count).to eq 0
      end

      it "returns a list of error messages" do
        data = response.parsed_body
        expect(data["errors"]).to contain_exactly("Email can't be blank", "Password can't be blank")
      end

      it "returns a HTTP status of unprocessable_entity" do
        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end
end

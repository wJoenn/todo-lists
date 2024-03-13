require "../../spec_helper"

describe Users::RegistrationsController do
  email = "user@example.com"
  password = "password"

  describe "GET /current_user" do
    context "when a User is authenticated" do
      user = User.new

      before_each do
        user = User.new({email: email})
        user.password = password
        user.save

        get "/current_user", HTTP::Headers{"Authorization" => user.jwt}
      end

      it "returns a JSON object" do
        NamedTuple(id: Int32).from_json(response.body)
        response.body?.should be_a String
      end

      it "returns the instance of User" do
        data = JSON.parse(response.body)
        data["id"].should eq user.id
      end

      it "returns a ok HTTP status" do
        response.status.should eq HTTP::Status::OK
      end
    end

    context "when a User is not authenticated" do
      it "returns a unauthorized HTTP status" do
        get "/current_user"
        response.status.should eq HTTP::Status::UNAUTHORIZED
      end
    end
  end

  describe "POST /users" do
    context "with proper params" do
      before_each do
        body = {
          user: {
            email:                 email,
            password:              password,
            password_confirmation: password,
          },
        }.to_json

        headers = HTTP::Headers{"Content-Type" => "application/json"}
        post "/users", headers: headers, body: body
      end

      it "returns a JSON object" do
        NamedTuple(id: Int32).from_json(response.body)
        response.body?.should be_a String
      end

      it "creates an instance of User" do
        User.all.count.should eq 1
      end

      it "returns the new instance of User" do
        data = JSON.parse(response.body)
        data["email"].should eq email
      end

      it "returns a created HTTP status" do
        response.status.should eq HTTP::Status::CREATED
      end

      it "returns a Authorization header" do
        response.headers["Authorization"].should eq User.all.first.try &.jwt
      end
    end

    context "without proper params" do
      before_each do
        body = {user: {email: nil, password: nil}}.to_json
        headers = HTTP::Headers{"Content-Type" => "application/json"}
        post "/users", headers: headers, body: body
      end

      it "returns a JSON object" do
        NamedTuple(errors: Hash(String, String)).from_json(response.body)
        response.body?.should be_a String
      end

      it "does not create an instance of User" do
        User.all.count.should eq 0
      end

      it "returns a list of error messages" do
        data = JSON.parse(response.body)
        data["errors"].as_h.should eq({"email" => "Email can't be blank", "password" => "Password can't be blank"})
      end

      it "returns a unprocessable_entity HTTP status" do
        response.status.should eq HTTP::Status::UNPROCESSABLE_ENTITY
      end
    end
  end
end

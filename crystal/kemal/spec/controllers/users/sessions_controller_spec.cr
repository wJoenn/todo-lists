require "../../spec_helper"

describe Users::SessionsController do
  email = "user@example.com"
  password = "password"
  user = User.new

  before_each do
    user = User.new({email: email})
    user.password = password
    user.save
  end

  describe "POST /users/sign_in" do
    context "with proper params" do
      before_each do
        body = {user: {email: email, password: password}}.to_json
        headers = HTTP::Headers{"Content-Type" => "application/json"}
        post "/users/sign_in", headers: headers, body: body
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

      it "returns a Authorization header" do
        response.headers["Authorization"].should eq user.jwt
      end
    end

    context "without proper params" do
      before_each do
        body = {user: {email: nil, password: nil}}.to_json
        headers = HTTP::Headers{"Content-Type" => "application/json"}
        post "/users/sign_in", headers: headers, body: body
      end

      it "returns a JSON object" do
        NamedTuple(errors: Hash(String, String)).from_json(response.body)
        response.body?.should be_a String
      end

      it "returns a list of error messages" do
        data = JSON.parse(response.body)
        data["errors"].as_h.should eq({"user" => "Invalid Email or Password"})
      end

      it "returns a unauthorized HTTP status" do
        response.status.should eq HTTP::Status::UNAUTHORIZED
      end
    end
  end

  describe "DELETE /users/sign_out" do
    context "when a User is authenticated" do
      before_each do
        delete "/users/sign_out", HTTP::Headers{"Authorization" => user.jwt}
      end

      it "signs the User out" do
        get "/current_user", HTTP::Headers{"Authorization" => user.jwt}
        response.status.should eq HTTP::Status::UNAUTHORIZED
      end

      it "returns a ok HTTP status" do
        response.status.should eq HTTP::Status::OK
      end
    end

    context "when a User is not authenticated" do
      it "returns a unauthorized HTTP status" do
        delete "/users/sign_out"

        response.status.should eq HTTP::Status::UNAUTHORIZED
      end
    end
  end
end

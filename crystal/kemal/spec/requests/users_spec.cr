describe "/users" do
  email = "user@example.com"
  password = "password"

  describe "POST /users" do
    context "with proper params" do
      before_each do
        post "/users",
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: {
            user: {
              email:                 email,
              password:              password,
              password_confirmation: password,
            },
          }.to_json
      end

      it "returns a JSON object" do
        response.body?.should be_a String
        JSON.parse(response.body).as_h.should be_a Hash(String, JSON::Any)
      end

      it "creates an instance of User" do
        User.all.count.should eq 1
      end

      it "returns the new instance of User" do
        data = JSON.parse(response.body)
        data["email"].should eq email
      end

      it "returns a HTTP status of created" do
        response.status.should eq HTTP::Status::CREATED
      end

      it "returns a Authorization header" do
        response.headers["Authorization"]?.should_not be_nil
      end
    end

    context "without proper params" do
      before_each do
        post "/users",
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: {user: {email: nil, password: nil}}.to_json
      end

      it "returns a JSON object" do
        response.body?.should be_a String
        JSON.parse(response.body).as_h.should be_a Hash(String, JSON::Any)
      end

      it "does not create an instance of User" do
        User.all.count.should eq 0
      end

      it "returns a list of error messages" do
        data = JSON.parse(response.body)
        errors = data["errors"].as_a
        errors.should contain "Email can't be blank"
        errors.should contain "Password can't be blank"
      end

      it "returns a HTTP status of unprocessable_entity" do
        response.status.should eq HTTP::Status::UNPROCESSABLE_ENTITY
      end
    end
  end

  describe "POST /users/sign_in" do
    context "with proper params" do
      before_each do
        user = User.new({email: email})
        user.password = password
        user.save

        post "/users/sign_in",
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: {user: {email: email, password: password}}.to_json
      end

      it "returns a JSON object" do
        response.body?.should be_a String
        JSON.parse(response.body).as_h.should be_a Hash(String, JSON::Any)
      end

      it "returns the instance of User" do
        data = JSON.parse(response.body)
        data["email"].should eq email
      end

      it "returns a HTTP status of ok" do
        response.status.should eq HTTP::Status::OK
      end

      it "returns a Authorization header" do
        response.headers["Authorization"]?.should_not be_nil
      end
    end

    context "without proper params" do
      before_each do
        post "/users/sign_in",
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: {user: {email: nil, password: nil}}.to_json
      end

      it "returns a JSON object" do
        response.body?.should be_a String
        JSON.parse(response.body).as_h.should be_a Hash(String, JSON::Any)
      end

      it "returns a list of error messages" do
        data = JSON.parse(response.body)
        errors = data["errors"].as_a
        errors.should contain "Invalid Email or Password"
      end

      it "returns a HTTP status of unauthorized" do
        response.status.should eq HTTP::Status::UNAUTHORIZED
      end
    end
  end

  describe "DELETE /users/sign_out" do
    jwt : String = ""

    before_each do
      user = User.new({email: email})
      user.password = password
      user.save

      jwt = user.jwt

      delete "/users/sign_out", HTTP::Headers{"Authorization" => jwt}
    end

    it "signs the User out" do
      get "/current_user", HTTP::Headers{"Authorization" => jwt}
      response.status.should eq HTTP::Status::UNAUTHORIZED
    end

    it "returns a HTTP status of ok" do
      response.status.should eq HTTP::Status::OK
    end
  end
end

describe "/current_user" do
  describe "GET /current_user" do
    context "with a valid JSON Web Token" do
      before_each do
        user = User.new({email: "user@example.com"})
        user.password = "password"
        user.save

        get "/current_user", HTTP::Headers{"Authorization" => user.jwt}
      end

      it "returns a JSON object" do
        response.body?.should be_a String
        JSON.parse(response.body).as_h.should be_a Hash(String, JSON::Any)
      end

      it "returns the instance of User" do
        data = JSON.parse(response.body)
        data["email"].should eq "user@example.com"
      end

      it "returns a HTTP status of ok" do
        response.status.should eq HTTP::Status::OK
      end
    end

    context "without a valid JSON Web Token" do
      it "returns a HTTP status of unauthorized" do
        get "/current_user"
        response.status.should eq HTTP::Status::UNAUTHORIZED
      end
    end
  end
end

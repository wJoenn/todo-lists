RSpec.describe "/current_user" do
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
end

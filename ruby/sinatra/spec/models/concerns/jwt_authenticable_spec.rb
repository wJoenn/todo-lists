RSpec.describe JwtAuthenticable do
  let(:user) { create(:user) }

  describe "::by_jwt" do
    it "returns the User when called with the User jti" do
      found_user = User.by_jwt(user.jwt)
      expect(found_user.id).to be user.id
    end

    it "returns nil when called with an incorrect jti" do
      expect(User.by_jwt("")).to be_nil
    end
  end

  describe "#edit_jti" do
    it "edits the User jti" do
      old_jti = user.jti
      user.edit_jti

      expect(old_jti).not_to eq user.jti
    end
  end

  describe "#jwt" do
    it "returns a Bearer User token" do
      expect(user.jwt).to match(/^Bearer .+/)
    end
  end

  describe "#to_json" do
    it "does not render the User's jti" do
      expect(JSON.parse(user.to_json)).not_to have_key "jti"
    end
  end
end

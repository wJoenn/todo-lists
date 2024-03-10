RSpec.describe DatabaseAuthenticable do
  let(:email) { "user@example.com" }
  let(:password) { "password" }
  let(:user) { create(:user, password:) }

  describe "validations" do
    it "validates the presence of the password" do
      user = User.create(email:)

      expect(user).not_to be_persisted
      expect(user.errors.full_messages).to contain_exactly "Password can't be blank"
    end

    it "validates the similarity of the password_confirmation and the password" do
      user = User.create(email:, password:, password_confirmation: "wrong")

      expect(user).not_to be_persisted
      expect(user.errors.full_messages).to contain_exactly "Password confirmation doesn't match Password"
    end
  end

  describe "#password" do
    it "returns the User password as a hash string" do
      expect(user.password).to eq password
      expect(password).not_to eq user.password
    end
  end

  describe "#password=" do
    it "updates the User encrypted_password" do
      user.update(password: "new password")
      expect(user.password).to eq "new password"
    end
  end

  describe "#to_json" do
    it "does not render the User's password" do
      %w[password password_confirmation encrypted_password].each do |key|
        expect(JSON.parse(user.to_json)).not_to have_key key
      end
    end
  end
end

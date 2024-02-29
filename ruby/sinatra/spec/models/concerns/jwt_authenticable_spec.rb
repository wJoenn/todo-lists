require_relative "../../sinatra_helper"

RSpec.describe JwtAuthenticable do
  let(:email) { "user@example.com" }
  let(:password) { "password" }
  let(:user) { create(:user, password:) }

  describe "validations" do
    it "validates the presence of the password" do
      user = User.create(email:)

      expect(user).not_to be_persisted
      expect(user.errors.full_messages).to contain_exactly "Password can't be blank"
    end

    it "validates that the password_confirmation is similar to the password" do
      user = User.create(email:, password:, password_confirmation: "wrong")

      expect(user).not_to be_persisted
      expect(user.errors.full_messages).to contain_exactly "Password confirmation doesn't match Password"
    end
  end

  describe "::FILTERED_ATTRIBUTES" do
    it "includes a list of filtered attributes" do
      expect(User::FILTERED_ATTRIBUTES).to contain_exactly :encrypted_password, :jti
    end
  end

  describe "::by_jwt" do
    it "returns the User when called with the User jti" do
      found_user = User.by_jwt(user.jwt)

      expect(found_user.id).to be user.id
    end

    it "returns nil when called with an incorrect jti" do
      expect(User.by_jwt("")).to be_nil
    end
  end

  describe "#jwt" do
    it "returns a Bearer User token" do
      expect(user.jwt).to match(/^Bearer .+/)
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
      user.password = "new password"
      user.save

      expect(user.password).to eq "new password"
    end
  end

  describe "#edit_jti" do
    it "edits the User jti" do
      old_jti = user.jti
      user.edit_jti

      expect(old_jti).not_to eq user.jti
    end
  end
end

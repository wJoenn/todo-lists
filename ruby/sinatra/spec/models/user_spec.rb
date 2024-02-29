require_relative "../sinatra_helper"

RSpec.describe User do
  let(:email) { "user@example.com" }
  let(:password) { "password" }

  describe "associations" do
    it "has many Task" do
      user = create(:user)
      create(:task, user:)

      expect(user.tasks).to all be_a Task
    end
  end

  describe "validations" do
    it "creates a new User with proper params" do
      user = described_class.create(email:, password:)
      expect(user).to be_persisted
      expect(user.errors.full_messages).to be_empty
    end

    it "validates the presence of the email" do
      user = described_class.create(password:)
      expect(user).not_to be_persisted
      expect(user.errors.full_messages).to contain_exactly "Email can't be blank"
    end

    it "validates the format of the email" do
      user = described_class.create(email: "wrong@email", password:)
      expect(user).not_to be_persisted
      expect(user.errors.full_messages).to contain_exactly "Email is invalid"
    end

    it "validates the presence of the password" do
      user = described_class.create(email:)
      expect(user).not_to be_persisted
      expect(user.errors.full_messages).to contain_exactly "Password can't be blank"
    end

    it "validates that the password_confirmation is similar to the password" do
      user = described_class.create(email:, password:, password_confirmation: "wrong")
      expect(user).not_to be_persisted
      expect(user.errors.full_messages).to contain_exactly "Password confirmation doesn't match Password"
    end
  end
end

require "rails_helper"

RSpec.describe User do
  describe "associations" do
    it "has many Task" do
      user = create(:user)
      expect(user.tasks).to all be_a Task
    end
  end

  describe "validations" do
    it "creates a new User with proper params" do
      user = described_class.create(email: "emai@example.com", password: "foobar")
      expect(user).to be_persisted
    end

    it "validates the presence of the email" do
      user = described_class.create(password: "foobar")
      expect(user).not_to be_persisted
    end

    it "validates the presence of the password" do
      user = described_class.create(email: "emai@example.com")
      expect(user).not_to be_persisted
    end

    it "validates that the password_confirmation is similar to the password" do
      user = described_class.create(email: "emai@example.com", password: "foobar", password_confirmation: "barfoo")
      expect(user).not_to be_persisted
    end
  end
end

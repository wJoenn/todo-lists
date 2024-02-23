require "rails_helper"

RSpec.describe Task do
  let!(:user) { create(:user) }

  describe "associations" do
    it "belongs to a User" do
      task = described_class.create(title: "My task", user:)
      expect(task.user).to be_a User
    end
  end

  describe "validations" do
    it "creates a new Task with proper params" do
      task = described_class.create(title: "My task", user:)
      expect(task).to be_persisted
    end

    it "validates the presence of the title" do
      task = described_class.create(user:)
      expect(task).not_to be_persisted
    end

    it "validates the presence of the User" do
      task = described_class.create(title: "My task")
      expect(task).not_to be_persisted
    end
  end
end

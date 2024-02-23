require "rails_helper"

RSpec.describe Task do
  describe "validations" do
    it "creates a new Task with proper params" do
      task = described_class.create(title: "My task")
      expect(task).to be_persisted
    end

    it "requires a title" do
      task = described_class.create
      expect(task).not_to be_persisted
    end
  end
end

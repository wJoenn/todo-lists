RSpec.describe Task do
  let(:title) { "My task" }
  let(:user) { create(:user) }

  describe "associations" do
    it "belongs to a User" do
      task = described_class.create(title:, user:)
      expect(task.user).to be_a User
    end
  end

  describe "validations" do
    it "creates a new Task with proper params" do
      task = described_class.create(title:, user:)

      expect(task).to be_persisted
      expect(task).not_to be_completed
    end

    it "validates the presence of the title" do
      task = described_class.create(user:)

      expect(task).not_to be_persisted
      expect(task.errors.full_messages).to contain_exactly "Title can't be blank"
    end

    it "validates the presence of the User" do
      task = described_class.create(title:)

      expect(task).not_to be_persisted
      expect(task.errors.full_messages).to contain_exactly "User must exist"
    end
  end
end

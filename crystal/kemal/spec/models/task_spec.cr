require "../spec_helper"

describe Task do
  title = "My task"

  describe "validations" do
    it "creates a new Task with proper params" do
      task = Task.create(title: title)

      task.valid?.should be_true
      task.completed.should be_false
    end

    it "validates the presence of the title" do
      task = Task.create

      task.valid?.should be_false
      task.errors.full_messages.should contain "Title can't be blank"
    end
  end
end

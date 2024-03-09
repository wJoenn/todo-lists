require "../spec_helper"

describe Task do
  title = "My task"
  user = User.new

  before_each do
    user = User.new({email: "user@example.com"})
    user.password = "password"
    user.save
  end

  describe "associations" do
    it "belongs to a User" do
      task = Task.create(title: title, user_id: user.id)
      task.user.should be_a User
    end
  end

  describe "validations" do
    it "creates a new Task with proper params" do
      task = Task.create(title: title, user_id: user.id)

      task.valid?.should be_true
      task.completed.should be_false
    end

    it "validates the presence of the title" do
      task = Task.create(user_id: user.id)

      task.valid?.should be_false

      messages = task.errors.full_messages
      messages.size.should eq 1
      messages.should contain "Title can't be blank"
    end

    it "validates the presence of the User" do
      task = Task.create(title: title)

      task.valid?.should be_false

      messages = task.errors.full_messages
      messages.size.should eq 1
      messages.should contain "User can't be blank"
    end
  end
end

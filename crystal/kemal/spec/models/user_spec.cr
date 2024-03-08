require "../spec_helper"

describe User do
  email = "user@example.com"
  password = "password"

  describe "associations" do
    it "has many Task" do
      user = create_user(email, password)
      Task.create(title: "My task", user_id: user.id)

      user.tasks.should be_a Array(Task)
    end
  end

  describe "validations" do
    it "creates a new User with proper params" do
      user = create_user(email, password)

      user.valid?.should be_true
    end

    it "validates the presence of the email" do
      user = create_user(nil, password)

      user.valid?.should be_false
      user.errors.full_messages.size.should eq 1
      user.errors.full_messages.should contain "Email can't be blank"
    end

    it "validates the format of the email" do
      user = create_user("wrong@example", password)

      user.valid?.should be_false
      user.errors.full_messages.size.should eq 1
      user.errors.full_messages.should contain "Email is invalid"
    end

    it "validates the presence of the password" do
      user = create_user(email, nil)

      user.valid?.should be_false
      user.errors.full_messages.size.should eq 1
      user.errors.full_messages.should contain "Password can't be blank"
    end

    it "validates that the password_confirmation is similar to the password" do
      user = User.new({email: email})
      user.password = password
      user.password_confirmation = "wrong"
      user.save

      user.valid?.should be_false
      user.errors.full_messages.size.should eq 1
      user.errors.full_messages.should contain "Password doesn't match Password"
    end
  end

  describe "::by_jwt" do
    it "returns the User when called with the User jti" do
      user = create_user(email, password)
      found_user = User.by_jwt(user.jwt)

      found_user.should_not be_nil
      found_user.try &.id.should eq user.id
    end

    it "returns nil when called with an incorrect jti" do
      User.by_jwt("").should be_nil
    end
  end

  describe "#edit_jti" do
    it "edits the User jti" do
      user = User.new({email: email})
      old_jti = user.jti
      user.edit_jti

      old_jti.should_not eq user.jti
    end
  end

  describe "#jwt" do
    it "returns a Bearer User token" do
      user = User.new({email: email})
      user.jwt.should match(/^Bearer .+/)
    end
  end
end

private def create_user(email, password)
  user = User.new({email: email})
  user.password = password
  user.password_confirmation = password
  user.save

  user
end

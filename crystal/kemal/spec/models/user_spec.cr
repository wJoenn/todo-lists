require "../spec_helper"

describe User do
  email = "user@example.com"
  password = "password"

  describe "validations" do
    it "creates a new User with proper params" do
      user = User.new({email: email})
      user.password = password
      user.password_confirmation = password
      user.save

      user.valid?.should be_true
    end

    it "validates the presence of the email" do
      user = User.new({email: nil})
      user.password = password
      user.save

      user.valid?.should be_false
      user.errors.full_messages.size.should eq 1
      user.errors.full_messages.should contain "Email can't be blank"
    end

    it "validates the format of the email" do
      user = User.new({email: "wrong@email"})
      user.password = password
      user.save

      user.valid?.should be_false
      user.errors.full_messages.size.should eq 1
      user.errors.full_messages.should contain "Email is invalid"
    end

    it "validates the presence of the password" do
      user = User.create({email: email})

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
end

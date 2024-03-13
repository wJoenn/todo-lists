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
    end

    it "validates the presence of the email" do
      user = described_class.create(password:)

      expect(user).not_to be_persisted
      expect(user.errors.full_messages).to contain_exactly "Email can't be blank"
    end

    it "validates the format of the email" do
      user = described_class.create(email: "wrong@example", password:)

      expect(user).not_to be_persisted
      expect(user.errors.full_messages).to contain_exactly "Email is invalid"
    end

    it "validates the uniqueness of the email" do
      described_class.create(email:, password:)
      user = described_class.create(email:, password:)

      expect(user).not_to be_persisted
      expect(user.errors.full_messages).to contain_exactly "Email has already been taken"
    end

    it "validates the presence of the password" do
      user = described_class.create(email:)

      expect(user).not_to be_persisted
      expect(user.errors.full_messages).to contain_exactly "Password can't be blank"
    end

    it "validates the similarity of the password_confirmation and the password" do
      user = described_class.create(email:, password:, password_confirmation: "wrong")

      expect(user).not_to be_persisted
      expect(user.errors.full_messages).to contain_exactly "Password confirmation doesn't match Password"
    end
  end

  describe "JSON Web Token" do
    it "expires after 30 days" do
      user = create(:user)
      _, payload = Warden::JWTAuth::UserEncoder.new.call(user, :user, "JWT_AUD")
      expect(Time.zone.at(payload["exp"]).to_date).to eq 30.days.from_now.to_date
    end
  end

  describe "#to_json" do
    let(:user) { create(:user) }
    let(:data) { JSON.parse(user.to_json) }

    it "does not render the User's password" do
      %w[password password_confirmation encrypted_password].each do |key|
        expect(data).not_to have_key key
      end
    end

    it "does not render the User's jti" do
      expect(data).not_to have_key "jti"
    end
  end
end

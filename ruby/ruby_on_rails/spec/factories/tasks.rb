FactoryBot.define do
  factory :task do
    title { "My task" }

    user { association :user }
  end
end

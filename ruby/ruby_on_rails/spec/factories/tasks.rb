FactoryBot.define do
  factory :task do
    title { "My task" }
    completed { false }

    user { association :user }
  end
end

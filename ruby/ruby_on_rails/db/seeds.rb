require "csv"

User.destroy_all

user = User.create(email: "user@example.com", password: "password")
CSV.read("#{__dir__}/static/tasks.csv", headers: true).each do |row|
  Task.create!(title: row["title"], completed: row["completed"], user:)
end

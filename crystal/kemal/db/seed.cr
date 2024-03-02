Sam.namespace "db" do
  task "seed" do
    task = Task.create(title: "My task")
    task.update(completed: true)
    task.destroy
  end
end

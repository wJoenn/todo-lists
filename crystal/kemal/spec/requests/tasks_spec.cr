describe "/tasks" do
  describe "GET /tasks" do
    before_each do
      Task.create(title: "My task")
      get "/tasks"
    end

    it "returns a JSON array" do
      response.body?.should be_a String

      tasks = Array(NamedTuple(id: Int32)).from_json(response.body)
      tasks.size.should eq Task.all.count
    end

    it "returns a list of Task" do
      data = JSON.parse(response.body)
      task = data.as_a.first

      task["title"].should eq "My task"
      task["completed"].should be_false
    end

    it "returns a HTTP status of success" do
      response.status.should eq HTTP::Status::OK
    end
  end

  describe "POST /tasks" do
    context "with proper params" do
      before_each do
        post "/tasks",
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: {task: {title: "My task"}}.to_json
      end

      it "returns a JSON array" do
        response.body?.should be_a String
        JSON.parse(response.body).as_h.should be_a Hash(String, JSON::Any)
      end

      it "creates an instance of Task" do
        Task.all.count.should eq 1
      end

      it "returns the new instance of Task" do
        data = JSON.parse(response.body)
        data["title"].should eq "My task"
      end

      it "returns a HTTP status of created" do
        response.status.should eq HTTP::Status::CREATED
      end
    end
  end

  context "without proper params" do
    before_each do
      post "/tasks",
        headers: HTTP::Headers{"Content-Type" => "application/json"},
        body: {task: {title: nil}}.to_json
    end

    it "returns a JSON object" do
      response.body?.should be_a String
      JSON.parse(response.body).as_h.should be_a Hash(String, JSON::Any)
    end

    it "does not create an instance of Task" do
      Task.all.count.should eq 0
    end

    it "returns a list of error messages" do
      data = JSON.parse(response.body)
      errors = data["errors"].as_a
      errors.should contain "Title can't be blank"
    end

    it "returns a HTTP status of unprocessable_entity" do
      response.status.should eq HTTP::Status::UNPROCESSABLE_ENTITY
    end
  end

  describe "DELETE /tasks/:id" do
    before_each do
      task = Task.create(title: "My task")
      delete "/tasks/#{task.id}"
    end

    it "destroys the instance of Task" do
      Task.all.count.should eq 0
    end

    it "returns a HTTP status of success" do
      response.status.should eq HTTP::Status::OK
    end
  end

  describe "PATCH /tasks/:id/complete" do
    it "returns a JSON array" do
      completed_task

      response.body?.should be_a String
      JSON.parse(response.body).as_h.should be_a Hash(String, JSON::Any)
    end

    it "returns the new instance of Task" do
      task = completed_task

      data = JSON.parse(response.body)
      data["id"].should eq task.id
    end

    it "marks the Task instance as completed" do
      task = completed_task

      completed = Task.find(task.id).try &.completed
      completed.should be_true
    end

    it "returns a HTTP status of success" do
      completed_task
      response.status.should eq HTTP::Status::OK
    end
  end
end

def completed_task
  task = Task.create(title: "My task")
  patch "/tasks/#{task.id}/complete"

  task
end

require "../spec_helper"

describe TasksController do
  title = "My task"
  user = User.new

  before_each do
    user = User.new({email: "user@example.com"})
    user.password = "password"
    user.save
  end

  describe "GET /tasks" do
    context "when a User is authenticated" do
      before_each do
        Task.create(title: title, user_id: user.id)
        get "/tasks", HTTP::Headers{"Authorization" => user.jwt}
      end

      it "returns a JSON array" do
        Array(NamedTuple(id: Int32)).from_json(response.body)
        response.body?.should be_a String
      end

      it "returns a list of Task" do
        data = JSON.parse(response.body).as_a

        data.each do |task|
          %w[id title].each do |key|
            task.as_h.has_key?(key).should be_true
          end
        end
      end

      it "returns a ok HTTP status" do
        response.status.should eq HTTP::Status::OK
      end
    end

    context "when a User is not authenticated" do
      it "returns a unauthorized HTTP status" do
        get "/tasks"
        response.status.should eq HTTP::Status::UNAUTHORIZED
      end
    end
  end

  describe "POST /tasks" do
    context "when a User is authenticated" do
      context "with proper params" do
        before_each do
          body = {task: {title: title}}.to_json
          headers = HTTP::Headers{"Content-Type" => "application/json", "Authorization" => user.jwt}
          post "/tasks", headers: headers, body: body
        end

        it "returns a JSON object" do
          NamedTuple(id: Int32).from_json(response.body)
          response.body?.should be_a String
        end

        it "creates an instance of Task" do
          Task.all.count.should eq 1
        end

        it "returns the new instance of Task" do
          data = JSON.parse(response.body)
          data["title"].should eq title
        end

        it "returns a created HTTP status" do
          response.status.should eq HTTP::Status::CREATED
        end
      end

      context "without proper params" do
        before_each do
          body = {task: {title: nil}}.to_json
          headers = HTTP::Headers{"Content-Type" => "application/json", "Authorization" => user.jwt}
          post "/tasks", headers: headers, body: body
        end

        it "returns a JSON object" do
          NamedTuple(errors: Hash(String, String)).from_json(response.body)
          response.body?.should be_a String
        end

        it "does not create an instance of Task" do
          Task.all.count.should eq 0
        end

        it "returns a list of error messages" do
          data = JSON.parse(response.body)
          data["errors"].as_h.should eq({"title" => "Title can't be blank"})
        end

        it "returns a unprocessable_entity HTTP status" do
          response.status.should eq HTTP::Status::UNPROCESSABLE_ENTITY
        end
      end
    end

    context "when a User is not authenticated" do
      it "returns a unauthorized HTTP status" do
        body = {task: {title: title}}.to_json
        headers = HTTP::Headers{"Content-Type" => "application/json"}
        post "/tasks", headers: headers, body: body

        response.status.should eq HTTP::Status::UNAUTHORIZED
      end
    end
  end

  describe "DELETE /tasks/:id" do
    task = Task.new

    before_each do
      task = Task.create(title: title, user_id: user.id)
    end

    context "when a User is authenticated" do
      context "when the Task is found" do
        before_each do
          delete "/tasks/#{task.id}", headers: HTTP::Headers{"Authorization" => user.jwt}
        end

        it "destroys the instance of Task" do
          Task.all.count.should eq 0
        end

        it "returns a ok HTTP status" do
          response.status.should eq HTTP::Status::OK
        end
      end

      context "when the Task is not found" do
        before_each do
          delete "/tasks/#{task.id.try &.+(1)}", headers: HTTP::Headers{"Authorization" => user.jwt}
        end

        it "returns a JSON object" do
          NamedTuple(errors: Hash(String, String)).from_json(response.body)
          response.body?.should be_a String
        end

        it "returns a list of error messages" do
          data = JSON.parse(response.body)
          data["errors"].as_h.should eq({"task" => "Task must exist"})
        end

        it "returns a not_found HTTP status" do
          response.status.should eq HTTP::Status::NOT_FOUND
        end
      end
    end

    context "when a User is not authenticated" do
      it "returns a HTTP status of unauthorized" do
        delete "/tasks/#{task.id}"

        response.status.should eq HTTP::Status::UNAUTHORIZED
      end
    end
  end

  describe "PATCH /tasks/:id/complete" do
    task = Task.new

    before_each do
      task = Task.create(title: "My task", user_id: user.id)
    end

    context "when a User is authenticated" do
      context "when the Task is found" do
        before_each do
          patch "/tasks/#{task.id}/complete", headers: HTTP::Headers{"Authorization" => user.jwt}
        end

        it "returns a JSON object" do
          NamedTuple(id: Int32).from_json(response.body)
          response.body?.should be_a String
        end

        it "returns the instance of Task" do
          data = JSON.parse(response.body)
          data["id"].should eq task.id
        end

        it "marks the Task as completed" do
          Task.find(task.id).try &.completed.should be_true
        end

        it "returns a ok HTTP status" do
          response.status.should eq HTTP::Status::OK
        end
      end

      context "when the Task is not found" do
        before_each do
          delete "/tasks/#{task.id.try &.+(1)}", headers: HTTP::Headers{"Authorization" => user.jwt}
        end

        it "returns a JSON object" do
          NamedTuple(errors: Hash(String, String)).from_json(response.body)
          response.body?.should be_a String
        end

        it "returns a list of error messages" do
          data = JSON.parse(response.body)
          data["errors"].as_h.should eq({"task" => "Task must exist"})
        end

        it "returns a not_found HTTP status" do
          response.status.should eq HTTP::Status::NOT_FOUND
        end
      end
    end

    context "when a User is not authenticated" do
      it "returns a unauthorized HTTP status" do
        patch "/tasks/#{task.id}/complete"

        response.status.should eq HTTP::Status::UNAUTHORIZED
      end
    end
  end
end

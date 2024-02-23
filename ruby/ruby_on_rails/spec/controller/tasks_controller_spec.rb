require "rails_helper"

RSpec.describe TasksController, type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET /tasks" do
    context "when a User is signed in" do
      before do
        create(:task, user:)
        get "/tasks"
      end

      it "returns a JSON object" do
        expect(response.body).to be_a String
        expect(response.parsed_body).to have_key "tasks"
      end

      it "returns a list of Task" do
        data = response.parsed_body
        expect(data["tasks"]).to contain_exactly hash_including("title" => "My task", "completed" => false)
      end

      it "returns a HTTP status of success" do
        expect(response).to have_http_status :success
      end
    end

    context "when a User is not signed in" do
      it "returns a HTTP status of unauthorized" do
        sign_out user
        get "/tasks"

        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe "POST /tasks" do
    context "when a User is signed in and with proper param" do
      before do
        post "/tasks", params: { task: { title: "My task" } }
      end

      it "returns a JSON object" do
        expect(response.body).to be_a String
        expect(response.parsed_body).to have_key "task"
      end

      it "creates an instance of Task" do
        expect(Task.count).to eq 1
      end

      it "returns the new instance of Task" do
        data = response.parsed_body
        expect(data.dig("task", "title")).to eq "My task"
      end

      it "returns a HTTP status of created" do
        expect(response).to have_http_status :created
      end
    end

    context "when a User is signed in but without proper params" do
      before do
        post "/tasks", params: { task: { title: nil } }
      end

      it "returns a JSON object" do
        expect(response.body).to be_a String
        expect(response.parsed_body).to have_key "errors"
      end

      it "does not create an instance of Task" do
        expect(Task.count).to eq 0
      end

      it "returns a list of error messages" do
        data = response.parsed_body
        expect(data["errors"]).to contain_exactly "Title can't be blank"
      end

      it "returns a HTTP status of unprocessable_entity" do
        expect(response).to have_http_status :unprocessable_entity
      end
    end

    context "when a User is not signed in" do
      it "returns a HTTP status of unauthorized" do
        sign_out user
        post "/tasks", params: { task: { title: "My task" } }

        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe "DELETE /tasks/:id" do
    context "when a User is signed in" do
      before do
        task = create(:task, user:)
        delete "/tasks/#{task.id}"
      end

      it "destroys the instance of Task" do
        expect(Task.count).to be 0
      end

      it "returns a HTTP status of success" do
        expect(response).to have_http_status :success
      end
    end

    context "when a User is not signed in" do
      it "returns a HTTP status of unauthorized" do
        sign_out user
        get "/tasks"

        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe "GET /tasks/:id/complete" do
    let!(:task) { create(:task, user:) }

    context "when a User is signed in" do
      before do
        patch "/tasks/#{task.id}/complete"
      end

      it "returns a JSON object" do
        expect(response.body).to be_a String
        expect(response.parsed_body).to have_key "task"
      end

      it "returns the updated instance of Task" do
        data = response.parsed_body
        expect(data.dig("task", "id")).to be task.id
      end

      it "marks the Task instance as completed" do
        expect(Task.find(task.id)).to be_completed
      end

      it "returns a HTTP status of success" do
        expect(response).to have_http_status :success
      end
    end

    context "when a User is not signed in" do
      it "returns a HTTP status of unauthorized" do
        sign_out user
        get "/tasks"

        expect(response).to have_http_status :unauthorized
      end
    end
  end
end

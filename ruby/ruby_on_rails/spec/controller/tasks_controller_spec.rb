RSpec.describe TasksController, type: :request do
  let(:title) { "My task" }
  let(:user) { create(:user) }

  describe "GET /tasks" do
    context "when a User is authenticated" do
      before do
        sign_in user
        create(:task, user:)
        get "/tasks"
      end

      it "returns a JSON array" do
        expect(response.body).to be_a String
        expect(response.parsed_body).to all have_key "id"
      end

      it "returns a list of Task" do
        data = response.parsed_body

        data.each do |task|
          %w[id title].each do |key|
            expect(task).to have_key key
          end
        end
      end

      it "returns a ok HTTP status" do
        expect(response).to have_http_status :ok
      end
    end

    context "when a User is not authenticated" do
      it "returns a unauthorized HTTP status" do
        get "/tasks"

        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe "POST /tasks" do
    context "when a User is authenticated" do
      before do
        sign_in user
      end

      context "with proper params" do
        before do
          post "/tasks", params: { task: { title: } }
        end

        it "returns a JSON object" do
          expect(response.body).to be_a String
          expect(response.parsed_body).to have_key "id"
        end

        it "creates an instance of Task" do
          expect(Task.count).to eq 1
        end

        it "returns the new instance of Task" do
          data = response.parsed_body
          expect(data["title"]).to eq title
        end

        it "returns a created HTTP status" do
          expect(response).to have_http_status :created
        end
      end

      context "without proper params" do
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
          expect(data["errors"]).to match({ title: "Title can't be blank" })
        end

        it "returns a unprocessable_entity HTTP status" do
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end

    context "when a User is not authenticated" do
      it "returns a unauthorized HTTP status" do
        post "/tasks", params: { task: { title: } }

        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe "DELETE /tasks/:id" do
    let(:task) { create(:task, user:) }

    context "when a User is authenticated" do
      before do
        sign_in user
      end

      context "when the Task is found" do
        before do
          delete "/tasks/#{task.id}"
        end

        it "destroys the instance of Task" do
          expect(Task.count).to be 0
        end

        it "returns a ok HTTP status" do
          expect(response).to have_http_status :ok
        end
      end

      context "when the Task is not found" do
        before do
          delete "/tasks/#{task.id + 1}"
        end

        it "returns a JSON object" do
          expect(response.body).to be_a String
          expect(response.parsed_body).to have_key "errors"
        end

        it "returns a list of error messages" do
          data = response.parsed_body
          expect(data["errors"]).to match({ task: "Task must exist" })
        end

        it "returns a not_found HTTP status" do
          expect(response).to have_http_status :not_found
        end
      end
    end

    context "when a User is not authenticated" do
      it "returns a unauthorized HTTP status" do
        delete "/tasks/#{task.id}"

        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe "PATCH /tasks/:id/complete" do
    let(:task) { create(:task, user:) }

    context "when a User is authenticated" do
      before do
        sign_in user
      end

      context "when the Task is found" do
        before do
          patch "/tasks/#{task.id}/complete"
        end

        it "returns a JSON object" do
          expect(response.body).to be_a String
          expect(response.parsed_body).to have_key "id"
        end

        it "returns the instance of Task" do
          data = response.parsed_body
          expect(data["id"]).to be task.id
        end

        it "marks the Task as completed" do
          expect(Task.find(task.id)).to be_completed
        end

        it "returns a ok HTTP status" do
          expect(response).to have_http_status :ok
        end
      end

      context "when the Task is not found" do
        before do
          patch "/tasks/#{task.id + 1}/complete"
        end

        it "returns a JSON object" do
          expect(response.body).to be_a String
          expect(response.parsed_body).to have_key "errors"
        end

        it "returns a list of error messages" do
          data = response.parsed_body
          expect(data["errors"]).to match({ task: "Task must exist" })
        end

        it "returns a not_found HTTP status" do
          expect(response).to have_http_status :not_found
        end
      end
    end

    context "when a User is not authenticated" do
      it "returns a unauthorized HTTP status" do
        patch "/tasks/#{task.id}/complete"

        expect(response).to have_http_status :unauthorized
      end
    end
  end
end

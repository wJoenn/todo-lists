RSpec.describe TasksController, type: :request do
  let(:title) { "My task" }
  let(:user) { create(:user) }

  describe "GET /tasks" do
    context "when a User is authenticated" do
      before do
        create(:task, user:)
        get "/tasks", nil, { "HTTP_AUTHORIZATION" => user.jwt }
      end

      it "returns a JSON array" do
        expect(last_response.body).to be_a String
        expect(JSON.parse(last_response.body)).to all have_key "id"
      end

      it "returns a list of Task" do
        data = JSON.parse(last_response.body)

        data.each do |task|
          %w[id title].each do |key|
            expect(task).to have_key key
          end
        end
      end

      it "returns a ok HTTP status" do
        expect(last_response.status).to be 200
      end
    end

    context "when a User is not authenticated" do
      it "returns a unauthorized HTTP status" do
        get "/tasks"

        expect(last_response.status).to be 401
      end
    end
  end

  describe "POST /tasks" do
    context "when a User is authenticated" do
      context "with proper params" do
        before do
          post "/tasks", { params: { task: { title: } } }, { "HTTP_AUTHORIZATION" => user.jwt }
        end

        it "returns a JSON object" do
          expect(last_response.body).to be_a String
          expect(JSON.parse(last_response.body)).to have_key "id"
        end

        it "creates an instance of Task" do
          expect(Task.count).to eq 1
        end

        it "returns the new instance of Task" do
          data = JSON.parse(last_response.body)
          expect(data["title"]).to eq title
        end

        it "returns a created HTTP status" do
          expect(last_response.status).to be 201
        end
      end

      context "without proper params" do
        before do
          post "/tasks", { params: { task: { title: nil } } }, { "HTTP_AUTHORIZATION" => user.jwt }
        end

        it "returns a JSON object" do
          expect(last_response.body).to be_a String
          expect(JSON.parse(last_response.body)).to have_key "errors"
        end

        it "does not create an instance of Task" do
          expect(Task.count).to eq 0
        end

        it "returns a list of error messages" do
          data = JSON.parse(last_response.body)
          expect(data["errors"]).to match({ "title" => "Title can't be blank" })
        end

        it "returns a HTTP status of unprocessable_entity" do
          expect(last_response.status).to be 422
        end
      end
    end

    context "when a User is not authenticated" do
      it "returns a unauthorized HTTP status" do
        post "/tasks", params: { task: { title: } }

        expect(last_response.status).to be 401
      end
    end
  end

  describe "DELETE /tasks/:id" do
    let(:task) { create(:task, user:) }

    context "when a User is authenticated" do
      context "when the Task is found" do
        before do
          delete "/tasks/#{task.id}", nil, { "HTTP_AUTHORIZATION" => user.jwt }
        end

        it "destroys the instance of Task" do
          expect(Task.count).to be 0
        end

        it "returns a ok HTTP status" do
          expect(last_response.status).to be 200
        end
      end

      context "when the Task is not found" do
        before do
          delete "/tasks/#{task.id + 1}", nil, { "HTTP_AUTHORIZATION" => user.jwt }
        end

        it "returns a JSON object" do
          expect(last_response.body).to be_a String
          expect(JSON.parse(last_response.body)).to have_key "errors"
        end

        it "returns a list of error messages" do
          data = JSON.parse(last_response.body)
          expect(data["errors"]).to match({ "task" => "Task must exist" })
        end

        it "returns a not_found HTTP status" do
          expect(last_response.status).to be 404
        end
      end
    end

    context "when a User is not authenticated" do
      it "returns a unauthorized HTTP status" do
        delete "/tasks/#{task.id}"

        expect(last_response.status).to be 401
      end
    end
  end

  describe "PATCH /tasks/:id/complete" do
    let!(:task) { create(:task, user:) }

    context "when a User is authenticated" do
      context "when the Task is found" do
        before do
          patch "/tasks/#{task.id}/complete", nil, { "HTTP_AUTHORIZATION" => user.jwt }
        end

        it "returns a JSON object" do
          expect(last_response.body).to be_a String
          expect(JSON.parse(last_response.body)).to have_key "id"
        end

        it "returns the instance of Task" do
          data = JSON.parse(last_response.body)
          expect(data["id"]).to be task.id
        end

        it "marks the Task as completed" do
          expect(Task.find(task.id)).to be_completed
        end

        it "returns a ok HTTP status" do
          expect(last_response.status).to be 200
        end
      end

      context "when the Task is not found" do
        before do
          patch "/tasks/#{task.id + 1}/complete", nil, { "HTTP_AUTHORIZATION" => user.jwt }
        end

        it "returns a JSON object" do
          expect(last_response.body).to be_a String
          expect(JSON.parse(last_response.body)).to have_key "errors"
        end

        it "returns a list of error messages" do
          data = JSON.parse(last_response.body)
          expect(data["errors"]).to match({ "task" => "Task must exist" })
        end

        it "returns a not_found HTTP status" do
          expect(last_response.status).to be 404
        end
      end
    end

    context "when a User is not authenticated" do
      it "returns a unauthorized HTTP status" do
        patch "/tasks/#{task.id}/complete"

        expect(last_response.status).to be 401
      end
    end
  end
end

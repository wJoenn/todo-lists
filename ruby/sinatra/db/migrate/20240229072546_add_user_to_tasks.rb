class AddUserToTasks < ActiveRecord::Migration[7.1]
  def change
    Task.destroy_all
    add_reference :tasks, :user, null: false, foreign_key: true
  end
end

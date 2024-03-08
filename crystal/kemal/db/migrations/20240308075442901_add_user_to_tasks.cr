class AddUserToTasks < Jennifer::Migration::Base
  def up
    Task.all.destroy

    change_table :tasks do |t|
      t.add_reference :user, :integer, {:null => false}
    end
  end

  def down
    change_table :users do |t|
      t.drop_reference :user
    end
  end
end

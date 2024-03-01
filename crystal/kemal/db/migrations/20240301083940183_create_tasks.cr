class CreateTasks < Jennifer::Migration::Base
  def up
    create_table :tasks do |t|
      t.string :title, { :null => false }
      t.bool :completed, { :null => false, :default => false }

      t.timestamps
    end
  end

  def down
    drop_table :tasks if table_exists? :tasks
  end
end

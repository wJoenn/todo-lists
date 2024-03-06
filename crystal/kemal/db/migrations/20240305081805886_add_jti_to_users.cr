class AddJtiToUsers < Jennifer::Migration::Base
  def up
    change_table :users do |t|
      t.add_column :jti, :string, {:null => true}
    end

    User.all.update(jti: UUID.random)

    change_table :users do |t|
      t.change_column :jti, :string, {:null => false}
      t.add_index :jti, type: :uniq
    end
  end

  def down
    change_table :users do |t|
      t.drop_column :jti
    end
  end
end

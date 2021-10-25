class AddNameAndParentToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :name, :string, null: false
    add_column :users, :parent_id, :integer
  end
end

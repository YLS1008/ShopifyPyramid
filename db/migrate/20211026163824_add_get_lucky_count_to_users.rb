class AddGetLuckyCountToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :get_lucky_count, :integer, default: 0
    add_column :users, :last_get_lucky_date, :date, default: 1.year.ago
  end
end

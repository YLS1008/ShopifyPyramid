class CreatePointTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :point_transactions do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.decimal :value
      t.integer :source

      t.timestamps
    end
  end
end

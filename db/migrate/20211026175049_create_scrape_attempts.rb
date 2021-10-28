class CreateScrapeAttempts < ActiveRecord::Migration[6.1]
  def change
    create_table :scrape_attempts do |t|
      t.bigint :last_transaction_id
      t.boolean :success

      t.timestamps
    end
  end
end

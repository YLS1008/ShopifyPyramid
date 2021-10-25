class CreateAuthenticationTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :authentication_tokens do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :token
      t.timestamp :expires_at
      t.boolean :valid

      t.timestamps
    end
  end
end

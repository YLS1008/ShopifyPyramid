class CreateInvitations < ActiveRecord::Migration[6.1]
  def change
    create_table :invitations do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :invited_email

      t.timestamps
    end
    add_index :invitations, :invited_email
  end
end

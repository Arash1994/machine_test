class CreateConversationsUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :conversations_users do |t|
      t.references :user, null: false, foreign_key: true
      t.references :conversation, null: false, foreign_key: true
    end
  end
end

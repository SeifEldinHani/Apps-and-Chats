class CreateChats < ActiveRecord::Migration[7.0]
  def change
    create_table :chats do |t|
      t.integer :chat_number, :null =>false
      t.integer :messages_count, :null =>false
      t.string :app_token, :null =>false
      t.timestamps
    end
    add_index :chats , :chat_number
  end
end

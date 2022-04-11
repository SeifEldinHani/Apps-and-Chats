class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.integer :message_number , :null =>false
      t.text :body, :null =>false
      t.string :app_token, :null =>false
      t.integer :chat_number, :null =>false
      t.timestamps
    end
    add_index :messages , :chat_number
  end
end

class CreateApps < ActiveRecord::Migration[7.0]
  def change
    create_table :apps do |t|
      t.string :name
      t.string :app_token
      t.integer :chat_count
      t.timestamps
    end
      add_index  :apps, :app_token, unique: true
  end
end

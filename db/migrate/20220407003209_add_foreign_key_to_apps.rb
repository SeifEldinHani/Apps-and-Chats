class AddForeignKeyToApps < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :chats, :apps, column: :app_token, primary_key: :app_token
  end
end

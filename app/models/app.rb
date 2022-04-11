class App < ApplicationRecord
    validates :name, presence: true
    has_many :chats , foreign_key: 'app_token', primary_key: 'app_token', dependent: :delete_all
    has_many :messages, foreign_key: 'app_token', primary_key: 'app_token', dependent: :delete_all
end

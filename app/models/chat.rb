class Chat < ApplicationRecord
  belongs_to :app , foreign_key: 'app_token', primary_key: 'app_token', optional: true
end

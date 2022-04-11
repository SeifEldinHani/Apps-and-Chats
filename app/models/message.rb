class Message < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks


  belongs_to :app , foreign_key: 'app_token', primary_key: 'app_token', optional: true
  validates :body, :chat_number, presence: true

  index_name    'messages'

  index_settings = {
    'analysis': {
      'filter': {
        'trigrams_filter': {
          'type': "ngram",
          'min_gram': 3,
          'max_gram': 3
        }
      },
      'analyzer': {
        'trigrams': {
          'type': 'custom',
          'tokenizer': 'standard',
          'filter': [
            'lowercase',
            'trigrams_filter'
          ]
        }
      }
    }
}
  settings index_settings do
    mappings do
        indexes :body, analyzer: 'trigrams'
        indexes :app_token
        indexes :chat_number
      end
    end

      

    def self.search(_query)

      __elasticsearch__.search({
        query: {
          bool: {
            must: [
              {
                match: {
                  body: _query["body"]
                }
              },
              {
                match: {
                  chat_number: _query["chat_number"]
                }
              },
              {
                match: {
                  app_token:_query["app_token"]
                }
              }
            ]
          }
        }
      }).records
    end
end

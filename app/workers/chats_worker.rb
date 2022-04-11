
class ChatsWorker
  include Sneakers::Worker

  from_queue "chat.queue", env: nil

  def work(raw_data)
    raw_json = JSON.parse(raw_data)
    chat = Chat.new(raw_json)
    chat.save!
    ack! 
  end
end

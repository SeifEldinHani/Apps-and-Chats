
class MessagesWorker
    include Sneakers::Worker

    from_queue "message.queue", env: nil

    def work(raw_data)
        raw_json = JSON.parse(raw_data)
        message = Message.new(raw_json)
        message.save!
        ack! 

    end
end

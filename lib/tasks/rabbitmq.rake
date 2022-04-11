namespace :rabbitmq do
  desc "Setup routing"
  task :setup do
    require "bunny"
    conn = Bunny.new({ host: 'rabbitmq' })
    conn.start

    ch = conn.create_channel

    x = ch.fanout("chat.instabug")
    y = ch.fanout("message.instabug")

    queue1 = ch.queue("chat.queue", durable: true)
    queue2 = ch.queue("message.queue", durable: true)

    queue1.bind("chat.instabug")
    queue2.bind("message.instabug")

    conn.close
  end
end
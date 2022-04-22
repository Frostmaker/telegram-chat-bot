# require_relative './constants'
require 'socket'
require 'bundler/setup'
Bundler.require(:default)
Dotenv.load

threads = []
TOKEN = ENV.fetch('TOKEN')
json_name = ENV.fetch('JSON_NAME')

Telegram::Bot::Client.run(TOKEN) do |bot|
  puts '--- START BOT ---'.colorize(:green)

  msg = nil
  reciever = Thread.new do
    bot.listen do |message|
      msg = message
      json_file = JSON.parse(File.read(json_name))

      unless json_file.value?(message.chat.id)
        json_file[[message.from.first_name, message.from.last_name].join(' ').rstrip] = message.chat.id
      end

      output = File.open(json_name, 'w+')
      output.write(JSON.generate(json_file))
      output.close

      print "#{'['.colorize(:red)}#{Time.at(message.date).to_s[11..15].colorize(:red)}#{']'.colorize(:red)} #{message.from.first_name.colorize(:blue)}#{message.from.last_name.nil? ? '' : ' '}#{message.from.last_name.colorize(:blue)}: #{message}\n"
      # bot.api.send_message(chat_id: 343090191, text: "#{message.chat.username}: #{message.chat.text)
    end
  end
  sender = Thread.new do
    loop do
      s = TCPSocket.new 'localhost', 2000
      uid = s.gets
      line = s.gets
      bot.api.send_message(chat_id: uid, text: line) unless line == '/q'
      s.close
    end
  end

  threads << reciever
  threads << sender
  threads.each(&:join)
end

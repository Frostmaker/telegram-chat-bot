require 'json'
require 'telegram/bot'
require 'colorize'
require './constants'
require 'socket'

threads = []

Telegram::Bot::Client.run(TOKEN) do |bot|
  puts '--- START BOT ---'.colorize(:green)

  msg = nil
  reciever = Thread.new do
    bot.listen do |message|
      msg = message
      json_file = JSON.parse(File.read('users_list.json'))

      unless json_file.has_value?(message.chat.id)
        json_file[[message.from.first_name, message.from.last_name].join(' ').rstrip] = message.chat.id
      end

      output = File.open('users_list.json', 'w+')
      output.write(JSON.generate(json_file))
      output.close

      print '['.colorize(:red) + Time.at(message.date).to_s[11..15].colorize(:red).to_s + ']'.colorize(:red) + " #{message.from.first_name.colorize(:blue)}#{message.from.last_name.nil? ? '' : ' ' + message.from.last_name.colorize(:blue)}: #{message}\n"
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

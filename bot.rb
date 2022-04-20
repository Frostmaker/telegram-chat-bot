require 'json'
require 'telegram/bot'
require 'colorize'
require './constants'

threads = []

Telegram::Bot::Client.run(TOKEN) do |bot|
  puts '--- START ---'.colorize(:green)

  json_file = JSON.parse(File.read('users_list.json'))
    bot.listen do |message|
      unless json_file.has_value?(message.chat.id)
        json_file[[message.from.first_name, message.from.last_name].join(' ').rstrip] = message.chat.id 
      end

      output = File.open('users_list.json', 'w+')
      output.write(JSON.generate(json_file))
      output.close

      print '['.colorize(:red) + Time.at(message.date).to_s[11..15].colorize(:red).to_s + ']'.colorize(:red) + " #{message.from.first_name.colorize(:blue)}#{message.from.last_name.nil? ? '' : ' ' + message.from.last_name.colorize(:blue)}: #{message}\n"
    
      print '>> '.colorize(:green)
      answer = gets.chomp
      bot.api.send_message(chat_id: message.chat.id, text: answer) unless answer.empty?
    end

  


  # threads << reciever
  # threads << sender
  # threads.each(&:join)
end

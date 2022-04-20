require 'json'
require 'telegram/bot'
require 'colorize'
require './constants'

Telegram::Bot::Client.run(TOKEN) do |bot|
  puts "--- START ---".colorize(:green)
  
  json_file = JSON.parse(File.read("users_list.json"))
  
  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
    when '/stop'
      bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
    else 
      unless json_file.include?(message.from.id.to_s)
        json_file[message.from.id] = [message.from.first_name, message.from.last_name].join(" ").rstrip
      end

      output = File.open("users_list.json", "w+")
      output.write(JSON.generate(json_file))
      output.close

      print "[".colorize(:red) + "#{(Time.at(message.date)).to_s[11..15].colorize(:red)}" + "]".colorize(:red) + " #{message.from.first_name.colorize(:blue)}#{message.from.last_name.nil? ? '' : ' ' + message.from.last_name.colorize(:blue)}: #{message}\n"
      print ">> ".colorize(:green)
      answer = gets.chomp
      bot.api.send_message(chat_id: message.chat.id, text: answer) if !answer.empty?
    
    end
  

  
  end
end
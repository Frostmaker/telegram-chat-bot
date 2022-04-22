require 'colorize'
require 'socket'
require 'json'
require 'dotenv'
Dotenv.load

json_name = ENV.include?('JSON_NAME') ? ENV['JSON_NAME'] : 'users_list.json'

unless File.exist?(json_name)
  f = File.open(json_name, 'w+')
  f.write('{}')
  f.close
end

server = TCPServer.new 2000 # Server bound to port 2000
text = ''
user = nil
puts '--- START SENDER ---'.colorize(:green)

client = server.accept
loop do
  client = server.accept unless user.nil?
  while user.nil?
    json_file = File.read(json_name)
    json_file = JSON.parse json_file
    print "CHATS: \n".colorize(:blue)
    json_file.each_key { |key| puts key.colorize(:yellow) }
    print 'Choose your company: '
    user_name = gets.chomp
    user = json_file[user_name]
  end
  while text.empty?
    print '>> '.colorize(:green)
    text = gets.chomp
  end
  if text == '/q'
    puts 'Выход из чата'
    user = nil
  else
    client.puts user
    client.puts text unless text.empty? || text.nil?
  end
  text = ''
end

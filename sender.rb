require 'colorize'
require 'socket'
require 'json'

server = TCPServer.new 2000 # Server bound to port 2000
text = ''
user = nil
puts '--- START SENDER ---'.colorize(:green)

client = server.accept # Wait for a client to connect
loop do
  unless user.nil?
    client = server.accept # Wait for a client to connect
  end
  while user.nil?
    json_file = File.read('users_list.json')
    json_file = JSON.parse json_file
    print "CHATS: \n".colorize(:blue)
    json_file.keys.each { |key| puts key.colorize(:yellow) }
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

# loop do
#   print '>> '.colorize(:green)
#   msg = gets.chomp
#   file = File.open('message.txt', 'w+')
#   file.write(msg)
#   file.close
# end

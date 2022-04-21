require 'colorize'
require 'socket'
require 'json'

server = TCPServer.new 2000 # Server bound to port 2000
text = ''
puts '--- START SENDER ---'.colorize(:green)

json_file = File.read("users_list.json")
json_file = JSON.parse json_file

print "CHATS: \n".colorize(:blue)
json_file.each {|key, val| puts key.colorize(:yellow)}

user = nil

loop do
  client = server.accept    # Wait for a client to connect
  while text.empty? do 
    print '>> '.colorize(:green)
    text = gets.chomp
  end
  client.puts text unless text.empty? || text.nil?
  text = ''
  # client.close
end

# loop do
#   print '>> '.colorize(:green)
#   msg = gets.chomp
#   file = File.open('message.txt', 'w+')
#   file.write(msg)
#   file.close
# end

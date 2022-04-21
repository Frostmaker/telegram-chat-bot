require 'colorize'
require 'socket'

server = TCPServer.new 2000 # Server bound to port 2000
text = ''
puts '--- START SENDER ---'.colorize(:green)

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

# require 'socket'
# server = TCPServer.new(1234)
# while connection = server.accept
# 	while line = connection.gets
#     break if line =~ /quit/
#     puts line
#     connection.puts "Received!"
#   end
#  connection.puts "Closing the connection. Bye!"

#  connection.close

# end


require 'socket'      # Sockets are in standard library

hostname = 'localhost'
port = 2000

s = TCPSocket.open(hostname, port)
server = TCPServer.new(1234)

while line = s.gets   # Read lines from the socket
  puts line.chop      # And print with platform line terminator
end
s.close               # Close the socket when done


require 'socket'

s = UDPSocket.new
s.bind(nil, 1234)

2.times do
  text, sender = s.recvfrom(16)
  puts text
end




require 'socket'

server= UDPSocket.new
server.bind('192.168.0.173', 3001)
loop do
    data,address=server.recvfrom(1024)
    server.send(data.reverse,0,address[3],address[1])  ############ My problem #########
    puts "get #{data} from #{address[3]}"
end



require 'socket'

server= UDPSocket.new
server.bind('172.31.14.4', 3000)
loop do
    data,address=server.recvfrom(1024)
    server.send(data.reverse,0,address[3],address[1])  ############ My problem #########
    puts "get #{data} from #{address[3]} = #{address[2]} = #{address[0]}"
    puts address.to_s
end


require 'socket'

server= UDPSocket.new
server.bind('192.168.0.173', 3001)
loop do
    data,address=server.recvfrom(1024)
    server.send(data.reverse,0,address[3],address[1])  ############ My problem #########
    puts "get #{data} from #{address[3]} = #{address[2]} = #{address[0]}"
    puts address.to_s
end



require 'socket'

server= UDPSocket.new
server.bind('localhost', 3000)
loop do
    data,address=server.recvfrom(1024)
    server.send(data.reverse,0,address[3],address[1])  ############ My problem #########
    puts "get #{data} from #{address[3]}"
end

require 'socket'
s = UDPSocket.new

s.send("hell5", 0, 'localhost', 1234)

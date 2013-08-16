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

while line = s.gets   # Read lines from the socket
  puts line.chop      # And print with platform line terminator
end
s.close               # Close the socket when done
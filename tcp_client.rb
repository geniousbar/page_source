#!/usr/bin/env ruby
require 'socket'


client = Socket.new(:INET, :STREAM);
any_addr = Socket.pack_sockaddr_in( 9000, '127.0.0.1')
client.connect(any_addr)
while (line = gets) != nil do
  client.close
  client.write(line)
  p "write done"
  if echo = client.gets
    p "server back: #{echo}"
  else
    p "server closed"
  end

end

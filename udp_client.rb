#!/usr/bin/env ruby
require 'socket'

cli = UDPSocket.new

while (line = gets) != nil do
  cli.send(line, 0, "127.0.0.1", 5000);
  p "write done"
  if echo = cli.recvfrom_nonblock(100)
    p "server back: #{echo}"
  else
    p "server closed"
  end

end
rog

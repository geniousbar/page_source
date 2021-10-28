#!/usr/bin/env ruby
require 'socket'

def echo(fb)
  while line = fb.gets do
    p "client send: #{line}"
    fb.write(line)
  end
  p "last rec: #{line}"
  sleep 2
  fb.write("xxxx")
  sleep 2
  p "write done"
  fb.close
end


server = Socket.new(:INET, :STREAM)
any_addr = Socket.pack_sockaddr_in(9000, '127.0.0.1')
server.bind(any_addr)
server.listen(100)
while item = server.accept()
  cli_conn, addr = item
  if pid = fork
    cli_conn.close
  else
    # p "cli pid #{Process.pid}"
    # cli_conn.close()
    begin
      echo(cli_conn)
    rescue Exception => e
      p "xxx #{e}"
    end
  end
end

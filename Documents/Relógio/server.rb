require 'webrick'

root = File.expand_path './public'

server = WEBrick::HTTPServer.new :Port => 8000, :DocumentRoot => root

puts "Servidor Ruby rodando em http://localhost:8000/"
puts "Pressione Ctrl+C para parar."

trap 'INT' do server.shutdown end

server.start
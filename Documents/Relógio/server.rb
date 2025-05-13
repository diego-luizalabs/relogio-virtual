require 'webrick'

# Define a pasta raiz de onde os arquivos serão servidos
root = File.expand_path './public'

# Configura o servidor
server = WEBrick::HTTPServer.new :Port => 8000, :DocumentRoot => root

# Mensagem no console indicando que o servidor iniciou
puts "Servidor Ruby rodando em http://localhost:8000/"
puts "Pressione Ctrl+C para parar."

# Trata o sinal de interrupção (Ctrl+C) para parar o servidor de forma elegante
trap 'INT' do server.shutdown end

# Inicia o servidor
server.start